#include <BluetoothSerial.h>

BluetoothSerial SerialBT; // Behaves like a Serial port, but the bytes travel over Bluetooth

bool isConnected = false; // Used to detect if the phone is connected / disconnected

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_BT");
  Serial2.begin(9600, SERIAL_8N1, 16, 17);  // RX=16, TX=17 → Nano

  Serial.println("Ready!");
}

void sendWelcome() {
  SerialBT.println("=== Connected! ===");
  SerialBT.println("Commands:");
  SerialBT.println("  LED_ON / LED_OFF");
  SerialBT.println("  MODE_AUTO / MODE_MANUAL");
  SerialBT.println("  THRESHOLD:XX (e.g. THRESHOLD:30)");
  SerialBT.println("Temperature updates every 2 seconds.");
  SerialBT.println("LED_STATE:ON / LED_STATE:OFF sent whenever the actual LED state changes.");
  SerialBT.println("==================");
}

void handleCommand(String command) {
  if (command == "LED_ON") {
    Serial2.print('1');
    //SerialBT.println("LED turned ON");
  }
  else if (command == "LED_OFF") {
    Serial2.print('0');
    //SerialBT.println("LED turned OFF");
  }
  else if (command == "MODE_AUTO") {
    Serial2.print('A');
    //SerialBT.println("Mode set to AUTO (LED follows temperature)");
  }
  else if (command == "MODE_MANUAL") {
    Serial2.print('M');
    //SerialBT.println("Mode set to MANUAL (LED follows button/app)");
  }
  else if (command.startsWith("THRESHOLD:")) {
    String value = command.substring(10);   // Extract number
    int threshold = value.toInt();

    // Validate range
    if (threshold < 0 || threshold > 50) {
      //SerialBT.println("Invalid threshold! Must be between 0 and 100.");
      return;
    }

    Serial2.print('T');                     // 'T' tells Nano to read next number
    Serial2.println(threshold);              // Nano uses parseInt() to read this
    //SerialBT.println("Threshold set to: " + String(threshold) + "°C");
  }
  else {
    //SerialBT.println("Unknown command: " + command);
  }
}

void loop() {
  // ---- Handle connection/disconnection ----
  if (SerialBT.connected() && !isConnected) {
    isConnected = true;
    Serial.println("Phone connected!");
    //sendWelcome();
  }
  if (!SerialBT.connected() && isConnected) {
    isConnected = false;
    Serial.println("Phone disconnected.");
  }

  // ---- Phone → ESP32 → Nano ----
  if (SerialBT.available()) {
    String command = SerialBT.readStringUntil('\n');
    command.trim();
    Serial.println("Command: " + command);
    handleCommand(command);
  }

  // ---- Nano → ESP32 → Phone ----
  if (Serial2.available()) {
    String msg = Serial2.readStringUntil('\n');
    msg.trim();
    Serial.println("From Nano: " + msg);

    if (msg.startsWith("LED:")) {
      // המצב הפיזי של הלד השתנה (כפתור, אפליקציה, או אוטומטי) -
      // נשלח לאפליקציה בפורמט מובחן כדי שתעדכן את צבע הכפתור
      String state = msg.substring(4);
      if (state == "1") {
        SerialBT.println("LED_STATE:ON");
      } else {
        SerialBT.println("LED_STATE:OFF");
      }
    }
	else if (msg.startsWith("MODE:")) {
      String state = msg.substring(5);
      if (state == "Auto") {
        SerialBT.println("MODE_STATE:AUTO");
      } else if (state == "Manual") {
        SerialBT.println("MODE_STATE:MANUAL");
      }
    }
	else {
      SerialBT.println(msg);
    }
  }
}