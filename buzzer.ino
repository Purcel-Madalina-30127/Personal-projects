void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:
  for(int frecv=500; frecv<2000; frecv=frecv+50){
    tone(7, frecv, 200);
    delay(50);
  }
  for(int frecv=2000; frecv>500; frecv=frecv-50){
    tone(7, frecv, 200);
    delay(50);
  }
}
