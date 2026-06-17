// -- Hardware Pins --
#define RED_PIN                     8
#define GREEN_PIN                   10
#define BUTTON_PIN                  2     // Must be an interrupt-capable pin

// -- Timing Constants --
#define MS_PER_TICK                 50
#define TIMER1_COMPARE_VALUE        3124  // (16MHz / (PRESCALER * 20Hz)) - 1 = 50ms tick, PRESCALER = 256

#define DEBOUNCE_MS                 50    // Minimum press duration to ignore button noise
#define LONG_PRESS_MS               4000  // 4s

#define NORMAL_WAIT_MS              5000  // 5s
#define EMERGENCY_WAIT_MS           2000  // 2s
#define NORMAL_GREEN_MS             5000  // 5s
#define EMERGENCY_GREEN_MS          8000  // 8s

#define ENTER_NORMAL_BLINK_COUNT    8     // Blink 8 times when entering normal mode
#define ENTER_EMERGENCY_BLINK_COUNT 4     // Blink 4 times when entering emergency mode
#define ENTER_NORMAL_BLINK_MS       500   // Blink for 0.5s (0.25s ON + 0.25s OFF) when entering normal mode
#define ENTER_EMERGENCY_BLINK_MS    1000  // Blink for 1s (0.5s ON + 0.5s OFF) when entering emergency mode

// -- Modes and States --
enum Mode  { NORMAL, EMERGENCY };
enum State { RED_PHASE, WAIT_PHASE, GREEN_PHASE, BLINK_PHASE };

// -- ISR-shared variables --
volatile unsigned long systemTicks = 0;		// Master clock: incremented every 50ms by Timer1 ISR
volatile unsigned long pressStartTicks = 0; // Tick count when button was pressed down
volatile unsigned long pressEndTicks = 0;	// Tick count when button was released
volatile bool buttonReleased = false;	    // Set by buttonISR

// -- Main program variables --
Mode currentMode = NORMAL;
State currentState = RED_PHASE;
unsigned long lastPressDurationMs = 0; // Duration of the last button press in ms
unsigned long phaseStartTicks = 0;     // Tick count when the current phase began
unsigned long targetTicks = 0;		   // Tick count at which the current phase should end
unsigned long nextToggleTick = 0;	   // Tick count at which the next LED toggle should happen
int togglesRemaining = 0;              // How many LED toggles are left
int toggleIntervalTicks = 0;		   // Ticks between each LED toggle


// -- Forward declarations --
void handleButtonPress();
void handleLongPress();
void handleShortPress();
void handleWaitPhase();
void handleGreenPhase();
void handleBlinkPhase();
void enterRedPhase();
void enterGreenPhase();
void startBlinking(int blinks, int intervalMs);
void setupTimer1();
unsigned long getSystemTicks();

// -- Main Program --

void setup() {
    Serial.begin(9600);
    pinMode(RED_PIN, OUTPUT);
    pinMode(GREEN_PIN, OUTPUT);
    pinMode(BUTTON_PIN, INPUT);

    // Initial state: red on, green off
    digitalWrite(RED_PIN, HIGH);
    digitalWrite(GREEN_PIN, LOW);

    attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonISR, CHANGE);
    setupTimer1();
}

void loop() {
    if (buttonReleased)           	 handleButtonPress();
    if (currentState == WAIT_PHASE)  handleWaitPhase();
    if (currentState == GREEN_PHASE) handleGreenPhase();
    if (currentState == BLINK_PHASE) handleBlinkPhase();
}

// -- Handlers --

// Computes press duration, prints it, then delegates to the appropriate handler
void handleButtonPress() {
    buttonReleased = false;
    lastPressDurationMs = (pressEndTicks - pressStartTicks) * MS_PER_TICK; // Calculate how long the button was held

    Serial.print("Button pressed for: ");
    Serial.print(lastPressDurationMs);
    Serial.println(" ms");

    if (lastPressDurationMs >= LONG_PRESS_MS) {
        handleLongPress(); // Trigger mode change
    } else if (lastPressDurationMs > DEBOUNCE_MS && currentState == RED_PHASE) {
        handleShortPress(); // Trigger state change
    }
}

// Long press: changes the mode and blinks to confirm the change
void handleLongPress() {
    currentMode = (currentMode == NORMAL) ? EMERGENCY : NORMAL; // Change the mode
    Serial.print("Mode switched to: ");
    Serial.println(currentMode == NORMAL ? "NORMAL" : "EMERGENCY");

    // Blink green LED to confirm the new mode: blink_count = how many blinks, blink_ms = how long each blink lasts
	if (currentMode == NORMAL) {
		startBlinking(ENTER_NORMAL_BLINK_COUNT, ENTER_NORMAL_BLINK_MS);
	} else {
		startBlinking(ENTER_EMERGENCY_BLINK_COUNT, ENTER_EMERGENCY_BLINK_MS);
	}
}

// Short press: changes the state to WAIT_PHASE to begin the crossing sequence
void handleShortPress() {
    phaseStartTicks = getSystemTicks();
	
	// Schedule the end of the wait phase based on the current mode
    targetTicks = phaseStartTicks + (currentMode == NORMAL ? NORMAL_WAIT_MS : EMERGENCY_WAIT_MS) / MS_PER_TICK;
    
	currentState = WAIT_PHASE;
    Serial.println("State switched to: WAIT_PHASE");
}

// Once WAIT_PHASE duration has passed, transitions to GREEN_PHASE
void handleWaitPhase() {
    if (getSystemTicks() < targetTicks) return; // WAIT_PHASE duration not passed

    unsigned long t = getSystemTicks();
    Serial.print("Time spent in WAIT_PHASE: ");
    Serial.print((t - phaseStartTicks) * MS_PER_TICK);
    Serial.println(" ms");

    enterGreenPhase();
}

// Once GREEN_PHASE duration has passed, transitions back to RED_PHASE
void handleGreenPhase() {
    if (getSystemTicks() < targetTicks) return; // GREEN_PHASE duration not passed

    unsigned long t = getSystemTicks();
    Serial.print("Time spent in GREEN_PHASE: ");
    Serial.print((t - phaseStartTicks) * MS_PER_TICK);
    Serial.println(" ms");

    enterRedPhase();
}

// Toggles the green LED on each interval tick and transitions to RED_PHASE when all toggles are done
void handleBlinkPhase() {
    if (getSystemTicks() < nextToggleTick) return; // Not time for next toggle yet

    unsigned long t = getSystemTicks();
    digitalWrite(GREEN_PIN, !digitalRead(GREEN_PIN)); // Toggle green LED
    togglesRemaining--;

    if (togglesRemaining > 0) {
        nextToggleTick = t + toggleIntervalTicks; // Schedule next toggle
    } else {
		// All toggles done, return to red
        Serial.print("Time spent in BLINK_PHASE: ");
        Serial.print((t - phaseStartTicks) * MS_PER_TICK);
        Serial.println(" ms");

        enterRedPhase();
    }
}

// -- Helper functions --

// Shared entry point for any phase transitioning to RED_PHASE
void enterRedPhase() {
    currentState = RED_PHASE;
    digitalWrite(RED_PIN, HIGH);  // Turn red on
    digitalWrite(GREEN_PIN, LOW); // Turn green off
    Serial.println("State switched to: RED_PHASE");
}

// Shared entry point for any phase transitioning to GREEN_PHASE
void enterGreenPhase() {
    phaseStartTicks = getSystemTicks();
    currentState = GREEN_PHASE;
    targetTicks = phaseStartTicks + (currentMode == NORMAL ? NORMAL_GREEN_MS : EMERGENCY_GREEN_MS) / MS_PER_TICK; // Schedule end of green phase
    digitalWrite(RED_PIN, LOW);   // Turn red off
    digitalWrite(GREEN_PIN, HIGH);// Turn green on
    Serial.println("State switched to: GREEN_PHASE");
}

// Blinking sequence initializer: sets up toggles count, interval, and schedules the first toggle
void startBlinking(int blinks, int intervalMs) {
    phaseStartTicks = getSystemTicks();
    currentState = BLINK_PHASE;
    togglesRemaining = blinks * 2;                          // ON is one toggle, OFF is another
    toggleIntervalTicks = (intervalMs / 2) / MS_PER_TICK;   // intervalMs is full blink, divide by 2 for each toggle
    nextToggleTick = phaseStartTicks + toggleIntervalTicks; // Schedule first toggle
    digitalWrite(RED_PIN, LOW);                             // Turn red OFF
    digitalWrite(GREEN_PIN, HIGH);                          // Start with green ON
    Serial.println("State switched to: BLINK_PHASE");
}

// Safe atomic read of systemTicks
unsigned long getSystemTicks() {
    cli(); 							// Disable interrupts to prevent mid-read update
    unsigned long t = systemTicks;
    sei(); 							// Re-enable interrupts
    return t;
}

// --- ISRs ---

// Fires on button press and release; records ticks and sets a flag
void buttonISR() {
    if (digitalRead(BUTTON_PIN) == HIGH) {
        pressStartTicks = systemTicks; // Record button press time
    } else {
        pressEndTicks  = systemTicks;  // Record button release time
        buttonReleased = true;         // Signal loop() to process the press
    }
}

// Fires every 50ms; advances the master clock by one tick
ISR(TIMER1_COMPA_vect) {
    systemTicks++;
}

// -- Timer1 Configuration --

void setupTimer1() {
    cli(); 							// Disable interrupts during setup
    TCCR1A = 0; 					// Clear control registers
    TCCR1B = 0;
    TCNT1  = 0; 					// Reset counter value
    OCR1A  = TIMER1_COMPARE_VALUE;
    TCCR1B |= (1 << WGM12); 		// CTC mode: reset counter on compare match
    TCCR1B |= (1 << CS12);  		// Prescaler: 256
    TIMSK1 |= (1 << OCIE1A);		// Enable compare match interrupt
    sei(); 							// Re-enable interrupts
}