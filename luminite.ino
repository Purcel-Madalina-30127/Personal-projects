int LEDPins[]= {2, 3, 4, 5, 6, 7};
int ledactual=5;
int timppeled=200;
unsigned long ultimastare=0;
void setup() {
  // put your setup code here, to run once:
  for(int i = 0; i< 6; i++){
    pinMode(LEDPins[i], OUTPUT);
  }
}
void loop() {
  // put your main code here, to run repeatedly:
  unsigned long timp = millis();
  if(timp-ultimastare>=timppeled){
    digitalWrite(LEDPins[ledactual],LOW);
    ledactual=(ledactual+1)%6;
    digitalWrite(LEDPins[ledactual],HIGH);
    ultimastare=timp;
  }
}
