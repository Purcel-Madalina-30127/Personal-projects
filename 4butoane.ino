void setup() {
  // put your setup code here, to run once:
  pinMode(3,INPUT_PULLUP);
  pinMode(4,INPUT_PULLUP);
  pinMode(5,INPUT_PULLUP);
  pinMode(6,INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int button1 = !digitalRead(3);
  int button2 = !digitalRead(4);
  int button3 = !digitalRead(5);
  int button4 = !digitalRead(6);
  if(button1==1){
    tone(7,300);
  }
  else if (button2==1){
    tone(7,500);
  }
  else if (button3==1){
    tone(7,800);
  }
  else if (button4==1){
    tone(7,300);
  }
  else{
    noTone(7);
  }
   
}
