#include "DHT.h"
#define dhtPin 12
#define dhtType DHT11
//DHT instance
DHT dht (dhtPin, dhtType);
float humidityVal;
float tempValC;
float tempValF;
float heatIndexC;
float heatIndexF;
void setup() {
  // put your setup code here, to run once:
  dht.begin();
  Serial.begin(9600);
}

void loop() {

humidityVal = dht.readHumidity();
tempValC = dht.readTemperature();
tempValF = dht.readTemperature(true);
if(isnan(humidityVal)||isnan(tempValC)||isnan(tempValF)){
  Serial.println("Reading DHT sensor failed");
  return;
}
heatIndexC=dht.computeHeatIndex(tempValC, humidityVal, false);
heatIndexF=dht.computeHeatIndex(tempValF, humidityVal);
Serial.println("Humidity=");
Serial.println(humidityVal);
Serial.println("%\t");

Serial.println("Temperature=");
Serial.println(tempValC);
Serial.println("'C");
Serial.println(tempValF);
Serial.println("'F\t");
Serial.println("Windchill=");
Serial.println(heatIndexC);
Serial.println("'C");
Serial.println(heatIndexF);
Serial.println("'F");
delay(2000);
 

}
