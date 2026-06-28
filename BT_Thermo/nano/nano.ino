#include <SoftwareSerial.h>
#include <TM1637Display.h>
#include <DHT.h>

// --- Pin definitions ---
#define BUTTON_PIN 2    // Push button SW4 (INT0)
#define DHTPIN 3        // DHT11 temperature sensor
#define CLK_PIN 4       // Display (CLK)
#define DIO_PIN 5       // Display (DIN/DIO)
#define LED_PIN 6       // LED
#define RX_PIN 10       // Connects to TX of ESP32
#define TX_PIN 11       // Connects to RX of ESP32

// --- DHT sensor setup ---
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// --- Communication and display objects ---
SoftwareSerial espSerial(RX_PIN, TX_PIN);
TM1637Display display(CLK_PIN, DIO_PIN);

// --- State variables ---
bool isAutoMode = false;
float thresholdTemp = 24.0;
volatile bool ledState = false;     // shared with the button ISR
float currentTemp = 0.0;
bool actualLedState = false;        // last physical LED state reported to the ESP32 (keeps the app button in sync)

// --- Timer1-based tick counter ---
// Timer1 runs in CTC mode with a prescaler of 64, generating an interrupt every 1ms.
// tickCount holds the number of milliseconds elapsed, incremented inside the Timer1 ISR.
volatile uint32_t tickCount = 0;

uint32_t lastTempReadTick = 0;
const uint32_t tempReadInterval = 2000;   // read temperature every 2000 ticks (2 seconds)

// --- Button debounce, based on tickCount ---
volatile uint32_t lastInterruptTick = 0;
const uint16_t debounceTicks = 50;        // 50 ticks = 50ms

// ---------------------------------------------------------------------------
// Timer1 setup: CTC mode, prescaler 64 -> interrupt every 1ms (at 16MHz)
// 16,000,000 / 64 = 250,000 ticks/sec -> OCR1A = 250-1 = 249 -> 1000Hz
// ---------------------------------------------------------------------------
void setupTimer1() {
  cli();
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;
  OCR1A  = 249;                          // compare value -> interrupt every 1ms
  TCCR1B |= (1 << WGM12);                // CTC mode (Clear Timer on Compare)
  TCCR1B |= (1 << CS11) | (1 << CS10);   // prescaler 64
  TIMSK1 |= (1 << OCIE1A);               // enable Compare Match A interrupt
  sei();
}

// Timer1 ISR - runs every 1ms, increments the tick counter
ISR(TIMER1_COMPA_vect) {
  tickCount++;
}

// ---------------------------------------------------------------------------
// Button ISR - triggered on FALLING edge (pin 2 = INT0).
// Debounced using tickCount: a press is only accepted if enough ticks have
// passed since the last accepted press.
// ---------------------------------------------------------------------------
void buttonISR() {
  uint32_t now = tickCount;
  if ((now - lastInterruptTick) >= debounceTicks) {
    if (!isAutoMode) {
      ledState = !ledState;
    }
    lastInterruptTick = now;
  }
}

void setup() {
  Serial.begin(9600);
  espSerial.begin(9600);
  dht.begin();             // initialize DHT11 sensor

  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  display.setBrightness(0x0f);
  display.clear();

  setupTimer1();
  attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonISR, FALLING);

  Serial.println("Arduino Nano + DHT11 Started.");
}

void loop() {
  handleESPCommands();
  handleTemperatureAndDisplay();
  updateLedLogic();
}

void handleESPCommands() {
  if (espSerial.available()) {
    char cmd = espSerial.read();

    switch (cmd) {
      case '1':
        if (!isAutoMode) ledState = true;
        break;
      case '0':
        if (!isAutoMode) ledState = false;
        break;
      case 'A':
        isAutoMode = true;
		espSerial.println("MODE:Auto");
        break;
      case 'M':
        isAutoMode = false;
		espSerial.println("MODE:Manual");
        break;
      case 'T':
        thresholdTemp = espSerial.parseInt();
        break;
    }
  }
}

void handleTemperatureAndDisplay() {
  // atomic read of tickCount (shared with the Timer1 ISR)
  cli();
  uint32_t now = tickCount;
  sei();

  if (now - lastTempReadTick >= tempReadInterval) {
    lastTempReadTick = now;

    // read temperature from the DHT11 sensor
    float t = dht.readTemperature();

    // check if the reading is valid
    if (isnan(t)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }

    currentTemp = t;

    // show on the 7-segment display
    display.showNumberDec((int)currentTemp, false);

    // send to the ESP32
    espSerial.print("TEMP:");
    espSerial.println(currentTemp);

    Serial.print("Current Temp: ");
    Serial.println(currentTemp);
  }
}

void updateLedLogic() {
  bool newState;

  if (isAutoMode) {
    newState = (currentTemp >= thresholdTemp);
  } else {
    newState = ledState;
  }

  digitalWrite(LED_PIN, newState ? HIGH : LOW);

  // if the physical LED state changed (switch, app, or automatic by temperature),
  // report it to the ESP32 so the app can sync its button color with the real LED state.
  if (newState != actualLedState) {
    actualLedState = newState;
    espSerial.print("LED:");
    espSerial.println(actualLedState ? 1 : 0);

    Serial.print("LED state changed -> reported: ");
    Serial.println(actualLedState);
  }
}
