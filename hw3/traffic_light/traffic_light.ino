// Hardware Pins
const int RED_PIN = 8;
const int GREEN_PIN = 10;
const int BUTTON_PIN = 2; // Must be an interrupt-capable pin

// Modes and States
enum Mode { NORMAL, EMERGENCY };
enum State { IDLE, WAITING, GREEN_LIGHT, BLINKING };

// Global Variables
Mode currentMode = NORMAL;

// State manager
volatile State currentState = IDLE;

// Button tracking
volatile unsigned long pressStartTicks = 0;  // Timestamp of when button was pressed
volatile bool triggerCycle = false;          // Flag for short press (start light cycle)
volatile bool toggleMode = false;            // Flag for long press (switch modes)
volatile unsigned long lastPressDurationMs = 0;
volatile bool printDuration = false;

// Timer and action tracking
volatile int timerTicks = 0;                 // General countdown timer
volatile int blinkTicks = 0;                 // Ticks between blink toggles
volatile int blinksRemaining = 0;            // How many toggles left
volatile bool actionReady = false;           // Flag indicating a timer finished

// System timekeeping
volatile unsigned long systemTicks = 0;      // Master clock: increments every 50ms
unsigned long waitingStartTicks = 0;         // Timestamp for entering WAITING
unsigned long blinkingStartTicks = 0;        // Timestamp for entering BLINKING
unsigned long greenStartTicks = 0;           // Timestamp for entering GREEN_LIGHT

void setup() {
    Serial.begin(9600); 
    pinMode(RED_PIN, OUTPUT);
    pinMode(GREEN_PIN, OUTPUT);
    pinMode(BUTTON_PIN, INPUT);

    // Initial default state: Red light on, Green light off
    digitalWrite(RED_PIN, HIGH);
    digitalWrite(GREEN_PIN, LOW);

    // Attach button interrupt
    attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonISR, CHANGE);
    
    // Start the background 50ms timer
    setupTimer1();
}

void loop() {
    // Print button press duration
    if (printDuration) {
        printDuration = false;
        Serial.print("Button pressed for: ");
        Serial.print(lastPressDurationMs);
        Serial.println(" ms");
    }

    // Handle Mode Switching (Long Press)
    if (toggleMode) {
        toggleMode = false;
        currentMode = (currentMode == NORMAL) ? EMERGENCY : NORMAL;
        
        Serial.print("Mode switched to: ");
        Serial.println(currentMode == NORMAL ? "NORMAL" : "EMERGENCY");
        
        // Start blinking based on the new mode
        if (currentMode == NORMAL) {
            startBlinking(8, 5); // 8 toggles, 250ms interval (5 * 50ms)
        } else {
            startBlinking(4, 10); // 4 toggles, 500ms interval (10 * 50ms)
        }
    }

    // Handle traffic light led cycle (short press)
    if (triggerCycle && currentState == IDLE) {
        // Enter waiting state before turning green
        triggerCycle = false;
        currentState = WAITING; 
        
        // Disable interrupts to safely read the volatile systemTicks and re-enable
        cli();
        waitingStartTicks = systemTicks; 
        sei();
        
        Serial.println("State switched to: WAITING");
        
        // Start a countdown based on current mode: 5s (100 ticks) or 2s (40 ticks)
        startDelay(currentMode == NORMAL ? 100 : 40); 
    }

    // Handle State Transitions (when countdown timer hits 0)
    if (actionReady) {
        actionReady = false; // Reset flag
        
        // switch from WAITING to GREEN_LIGHT state
        if (currentState == WAITING) {
            // calculate waiting time
            cli();
            unsigned long waitingTimeMs = (systemTicks - waitingStartTicks) * 50; 
            sei();
            
            Serial.print("Time spent WAITING: ");
            Serial.print(waitingTimeMs);
            Serial.println(" ms");

            currentState = GREEN_LIGHT;
            
            // save green light starting time ticks
            cli();
            greenStartTicks = systemTicks;
            sei();
            
            Serial.println("State switched to: GREEN_LIGHT");
            
            // Switch physical LEDs
            digitalWrite(RED_PIN, LOW);
            digitalWrite(GREEN_PIN, HIGH);
            
            // Start green duration countdown: 5s (100 ticks) or 8s (160 ticks)
            startDelay(currentMode == NORMAL ? 100 : 160); 
            
        // switch from GREEN_LIGHT or BLINKING to IDLE state
        } else if (currentState == GREEN_LIGHT || currentState == BLINKING) {
            
            // Calculate and print duration of the state we just finished
            if (currentState == BLINKING) {
                cli();
                unsigned long blinkingTimeMs = (systemTicks - blinkingStartTicks) * 50; 
                sei();
                
                Serial.print("Time spent BLINKING: ");
                Serial.print(blinkingTimeMs);
                Serial.println(" ms");
            } else if (currentState == GREEN_LIGHT) {
                cli();
                unsigned long greenTimeMs = (systemTicks - greenStartTicks) * 50; 
                sei();
                
                Serial.print("Time spent GREEN_LIGHT: ");
                Serial.print(greenTimeMs);
                Serial.println(" ms");
            }

            // Return to IDLE state
            currentState = IDLE;
            Serial.println("State switched to: IDLE");
            digitalWrite(RED_PIN, HIGH);
            digitalWrite(GREEN_PIN, LOW);
        }
    }
}

// Interrupt Service Routine for the Button
// activates when button is pressed or released
void buttonISR() {
    if (digitalRead(BUTTON_PIN) == HIGH) {
        // Button pressed, Record start time
        pressStartTicks = systemTicks;
    } else {
        // Button released, calculate how long it was pressed for
        unsigned long durationMs = (systemTicks - pressStartTicks) * 50;
        lastPressDurationMs = durationMs;
        // Signal main loop to print the duration
        printDuration = true; 

        // Switch mode if button was pressed for 4 seconds
        if (durationMs >= 4000) {
            toggleMode = true;     
        // Cycle traffic light leds for short press (4000ms > duration > 50ms)
        } else if (durationMs > 50) { 
            triggerCycle = true;   
        }
    }
}

// Interrupt Service Routine for Timer1
// activates every 50ms
ISR(TIMER1_COMPA_vect) {
    systemTicks++; // Advance the master clock by 1 tick (50ms)

    if (currentState == BLINKING) {
        // Handle blink logic: count down to next LED toggle
        if (timerTicks > 0) {
            timerTicks--;
            if (timerTicks == 0) {
                // Time to toggle the green LED state
                digitalWrite(GREEN_PIN, !digitalRead(GREEN_PIN)); 
                blinksRemaining--;
                
                if (blinksRemaining > 0) {
                    timerTicks = blinkTicks; // Reset timer for the next toggle
                } else {
                    actionReady = true; // Blinking sequence finished, signal main loop
                }
            }
        }
    } else if (currentState == WAITING || currentState == GREEN_LIGHT) {
        // Handle standard delay countdown logic
        if (timerTicks > 0) {
            timerTicks--;
            if (timerTicks == 0) {
                actionReady = true; // Delay finished, signal main loop to transition states
            }
        }
    }
}

// Timer1 Configuration
// Configures hardware Timer1 to activate interrupt every 50ms
void setupTimer1() {
    cli(); // Disable interrupts during setup
    TCCR1A = 0; // Clear control registers
    TCCR1B = 0;
    TCNT1  = 0; // Reset counter value
    
    // Set Compare Match Register for 20Hz (50ms)
    // Formula: (16MHz / (Prescaler * Target_Frequency)) - 1
    // (16,000,000 / (256 * 20)) - 1 = 3124
    OCR1A = 3124; 
    
    TCCR1B |= (1 << WGM12);  // Turn on CTC (Clear Timer on Compare Match) mode
    TCCR1B |= (1 << CS12);   // Set Prescaler to 256
    TIMSK1 |= (1 << OCIE1A); // Enable timer compare interrupt
    sei(); // enable interrupts
}

// Start a standard delay
void startDelay(int ticks) {
    // Set the countdown variable read by the Timer ISR
    cli();
    timerTicks = ticks; 
    sei();
}

// Initialize a blinking sequence
void startBlinking(int blinks, int tickInterval) {
    Serial.println("State switched to: BLINKING");
    
    cli();
    blinkingStartTicks = systemTicks; 
    currentState = BLINKING;
    blinksRemaining = blinks * 2; // Multiply by 2 (one toggle for ON, one for OFF)
    blinkTicks = tickInterval;
    timerTicks = tickInterval;
    
    // Ensure standard starting physical state
    digitalWrite(RED_PIN, LOW);
    digitalWrite(GREEN_PIN, HIGH); 
    sei();
}