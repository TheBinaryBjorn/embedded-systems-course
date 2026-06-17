#include <SoftwareSerial.h>
#include <TM1637Display.h>
#include <DHT.h>

// --- הגדרות פינים מעודכנות ---
#define BUTTON_PIN 2    // לחצן SW4
#define DHTPIN 3        // חיישן טמפרטורה DHT11
#define CLK_PIN 4       // מסך (CLK)
#define DIO_PIN 5       // מסך (DIN/DIO)
#define LED_PIN 6       // נורית LED
#define RX_PIN 10       // מתחבר ל-TX של ESP32
#define TX_PIN 11       // מתחבר ל-RX של ESP32

// --- הגדרת חיישן DHT ---
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// --- יצירת אובייקטים לתקשורת ולמסך ---
SoftwareSerial espSerial(RX_PIN, TX_PIN);
TM1637Display display(CLK_PIN, DIO_PIN);

// --- משתני לוגיקה ומצב ---
bool isAutoMode = false;     
float thresholdTemp = 24.0;  
bool ledState = false;       
float currentTemp = 0.0;     

// --- משתני זמן (ללא delay) ---
unsigned long lastTempReadTime = 0;
const unsigned long tempReadInterval = 2000; // DHT11 איטי, מומלץ לקרוא פעם ב-2 שניות

// --- משתני Debounce ללחצן ---
int lastButtonState = HIGH;
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;

void setup() {
  Serial.begin(9600);      
  espSerial.begin(9600);   
  dht.begin();             // אתחול חיישן DHT11

  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  display.setBrightness(0x0f); 
  display.clear();
  
  Serial.println("Arduino Nano + DHT11 Started.");
}

void loop() {
  handleButton();
  handleESPCommands();
  handleTemperatureAndDisplay();
  updateLedLogic();
}

void handleButton() {
  int reading = digitalRead(BUTTON_PIN);

  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading == LOW && !isAutoMode) {
      ledState = !ledState; 
      while(digitalRead(BUTTON_PIN) == LOW); // המתנה לשחרור
      Serial.print("Button Pressed. LED State: ");
      Serial.println(ledState);
    }
  }
  lastButtonState = reading;
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
        break;
      case 'M': 
        isAutoMode = false;
        break;
      case 'T': 
        thresholdTemp = espSerial.parseInt();
        break;
    }
  }
}

void handleTemperatureAndDisplay() {
  if (millis() - lastTempReadTime >= tempReadInterval) {
    lastTempReadTime = millis();

    // קריאת טמפרטורה מחיישן DHT11
    float t = dht.readTemperature();

    // בדיקה אם הקריאה תקינה
    if (isnan(t)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }

    currentTemp = t;

    // הצגה על מסך 7-SEG
    display.showNumberDec((int)currentTemp, false); 

    // שליחה ל-ESP32
    espSerial.print("TEMP:");
    espSerial.println(currentTemp);
    
    Serial.print("Current Temp: ");
    Serial.println(currentTemp);
  }
}

void updateLedLogic() {
  if (isAutoMode) {
    if (currentTemp >= thresholdTemp) {
      digitalWrite(LED_PIN, HIGH);
    } else {
      digitalWrite(LED_PIN, LOW);
    }
  } else {
    digitalWrite(LED_PIN, ledState ? HIGH : LOW);
  }
}