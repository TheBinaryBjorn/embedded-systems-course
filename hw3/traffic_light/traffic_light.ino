// C++ code
//
#define GREEN_LED 10
#define RED_LED 8
#define BUTTON 2

enum Mode {
  REGULAR,
  EMERGENCY
};

enum Mode current_mode = REGULAR;

void setup()
{
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BUTTON), handle_button_press, FALLING);
}

void loop()
{
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000); // Wait for 1000 millisecond(s)
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000); // Wait for 1000 millisecond(s)
}

void handle_button_press()
{
  if (current_mode == REGULAR) {
    // wait 5 sec

    // turn green led on for 5 sec

    // turn red led on
  } else {
    // wait 2 sec

    // turn green led on for 8 sec

    // turn red led on
  }
} 