#include <BluetoothSerial.h>

// Behaves like a Serial port, but the bytes travel over Bluetooth
BluetoothSerial SerialBT; 

// Used to detect if the phone is connected / disconnected
bool isConnected = false; 

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_BT");
  Serial2.begin(9600, SERIAL_8N1, 16, 17);  // RX=16, TX=17 -> Nano

  Serial.println("Ready!");
}

// Parses a command string received from the phone and forwards the appropriate
// byte(s) to the Nano over UART. The Nano is responsible for acting on them.
void handleCommand(String command) {
  // Tell Nano to turn the LED on
  if (command == "LED_ON") {
    Serial2.print('1');
  }

  // Tell Nano to turn the LED off
  else if (command == "LED_OFF") {
    Serial2.print('0');
  }

  // Switch Nano to automatic mode (LED follows temperature)
  else if (command == "MODE_AUTO") {
    Serial2.print('A');
  }

  // Switch Nano to manual mode (LED controlled by app/button only)
  else if (command == "MODE_MANUAL") {
    Serial2.print('M');
  }

  // Expected format: "THRESHOLD:XX" where XX is a number between 0–50
  else if (command.startsWith("THRESHOLD:")) {
    String value = command.substring(10);   // Extract number
    int threshold = value.toInt();

    // Validate range
    if (threshold < 0 || threshold > 50) {
      return;
    }


    // Two-part message to Nano:
    // 1. 'T' signals that a new threshold value is coming next
    // 2. The number as ASCII text — Nano reads it with parseInt()
    Serial2.print('T');
    Serial2.println(threshold);
  }
}

void loop() {
  // ---- Handle connection/disconnection ----
  if (SerialBT.connected() && !isConnected) {
    isConnected = true;
    Serial.println("Phone connected!");
  }
  if (!SerialBT.connected() && isConnected) {
    isConnected = false;
    Serial.println("Phone disconnected.");
  }

  // ---- Phone -> ESP32 -> Nano ----
  // Read one full command line from the phone (terminated by '\n'),
  // clean up any trailing whitespace, then send it.
  if (SerialBT.available()) {
    String command = SerialBT.readStringUntil('\n');
    command.trim();
    Serial.println("Command: " + command);
    handleCommand(command);
  }

  // ---- Nano -> ESP32 -> Phone ----
  // The Nano proactively sends two kinds of messages:
  //   "LED:1" / "LED:0"      — LED state changed (by button, app, or auto mode)
  //   "MODE:Auto" / "MODE:Manual" — mode changed
  //   Anything else (e.g. "TEMP:27") — forwarded as-is to the phone
  if (Serial2.available()) {
    String msg = Serial2.readStringUntil('\n');
    msg.trim();
    Serial.println("From Nano: " + msg);

    if (msg.startsWith("LED:")) {
      // Translate Nano's compact "LED:1/0" into a readable protocol token for the app.
      // The app uses "LED_STATE:ON/OFF" to update the button color in the UI.
      String state = msg.substring(4);
      if (state == "1") {
        SerialBT.println("LED_STATE:ON");
      } else {
        SerialBT.println("LED_STATE:OFF");
      }
    }
	else if (msg.startsWith("MODE:")) {
      // Translate Nano's mode report into a UI-friendly token for the app.
      String state = msg.substring(5);
      if (state == "Auto") {
        SerialBT.println("MODE_STATE:AUTO");
      } else if (state == "Manual") {
        SerialBT.println("MODE_STATE:MANUAL");
      }
    }
	else {
      // Pass-through: forward any other Nano message (e.g. temperature readings)
      // directly to the phone without modification.
      SerialBT.println(msg);
    }
  }
}