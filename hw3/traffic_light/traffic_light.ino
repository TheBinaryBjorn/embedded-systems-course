const int RED_PIN = 8;
const int GREEN_PIN = 10;
const int BUTTON_PIN = 2;

enum Mode { NORMAL, EMERGENCY };
enum State { IDLE, WAITING, GREEN_LIGHT, BLINKING };

Mode currentMode = NORMAL;
volatile State currentState = IDLE;

volatile unsigned long pressStartTime = 0;
volatile bool triggerCycle = false;
volatile bool toggleMode = false;

volatile int timerTicks = 0;
volatile int blinkTicks = 0;
volatile int blinksRemaining = 0;
volatile bool actionReady = false;

void setup() {
    pinMode(RED_PIN, OUTPUT);
    pinMode(GREEN_PIN, OUTPUT);
    pinMode(BUTTON_PIN, INPUT); // Assumes external pull-down resistor

    digitalWrite(RED_PIN, HIGH);
    digitalWrite(GREEN_PIN, LOW);

    // Attach interrupt for the button
    attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonISR, CHANGE);
    
    // Initialize hardware Timer1
    setupTimer1();
}

void loop() {
    // Handle Mode Switching (Long Press)
    if (toggleMode) {
        toggleMode = false;
        currentMode = (currentMode == NORMAL) ? EMERGENCY : NORMAL;
        
        if (currentMode == NORMAL) {
            startBlinking(8, 5); // 8 blinks, 5 ticks (250ms) per toggle
        } else {
            startBlinking(4, 10); // 4 blinks, 10 ticks (500ms) per toggle
        }
    }

    // Handle Button Press (Short Press)
    if (triggerCycle && currentState == IDLE) {
        triggerCycle = false;
        currentState = WAITING;
        startDelay(currentMode == NORMAL ? 100 : 40); // 5s (100 ticks) or 2s (40 ticks)
    }

    // Handle Timer Completions
    if (actionReady) {
        actionReady = false;
        
        if (currentState == WAITING) {
            currentState = GREEN_LIGHT;
            digitalWrite(RED_PIN, LOW);
            digitalWrite(GREEN_PIN, HIGH);
            startDelay(currentMode == NORMAL ? 100 : 160); // 5s or 8s
            
        } else if (currentState == GREEN_LIGHT || currentState == BLINKING) {
            currentState = IDLE;
            digitalWrite(RED_PIN, HIGH);
            digitalWrite(GREEN_PIN, LOW);
        }
    }
}

// ISR for Button Press
void buttonISR() {
    if (digitalRead(BUTTON_PIN) == HIGH) {
        pressStartTime = millis();
    } else {
        unsigned long duration = millis() - pressStartTime;
        if (duration >= 4000) {
            toggleMode = true;
        } else if (duration > 50) { // 50ms debounce
            triggerCycle = true;
        }
    }
}

// ISR for Hardware Timer1 (Fires every 50ms)
ISR(TIMER1_COMPA_vect) {
    if (currentState == BLINKING) {
        if (timerTicks > 0) {
            timerTicks--;
            if (timerTicks == 0) {
                digitalWrite(GREEN_PIN, !digitalRead(GREEN_PIN)); // Toggle LED
                blinksRemaining--;
                if (blinksRemaining > 0) {
                    timerTicks = blinkTicks;
                } else {
                    actionReady = true;
                }
            }
        }
    } else if (currentState == WAITING || currentState == GREEN_LIGHT) {
        if (timerTicks > 0) {
            timerTicks--;
            if (timerTicks == 0) {
                actionReady = true;
            }
        }
    }
}

// Helper: Setup Timer1 for 50ms intervals (20Hz)
void setupTimer1() {
    cli();
    TCCR1A = 0;
    TCCR1B = 0;
    TCNT1  = 0;
    OCR1A = 3124; // (16,000,000 / (256 * 20)) - 1
    TCCR1B |= (1 << WGM12); 
    TCCR1B |= (1 << CS12);  
    TIMSK1 |= (1 << OCIE1A); 
    sei();
}

// Helper: Start a standard delay
void startDelay(int ticks) {
    cli();
    timerTicks = ticks;
    sei();
}

// Helper: Start the blinking sequence
void startBlinking(int blinks, int tickInterval) {
    cli();
    currentState = BLINKING;
    blinksRemaining = blinks * 2; // Multiply by 2 for ON and OFF phases
    blinkTicks = tickInterval;
    timerTicks = tickInterval;
    digitalWrite(RED_PIN, LOW);
    digitalWrite(GREEN_PIN, HIGH); // Start with green on
    sei();
}