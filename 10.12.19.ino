unsigned long previousMillis = 0;
unsigned long timeLed = 4000;
int i = 0;
int wait = 0;
int routine= 0;
int pwm1 = 0;
int pwm2 = 0;
int type=0;

void setup() {
  // put your setup code here, to run once:
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT);
  // initialize serial communication at 19200 bits per second:
  Serial.begin(19200);

}

void loop() {
  i=0;
  wait=0;
  pwm1=0;
  pwm2=0;
 
  
  while (wait != 1 && Serial.available()==4) {
    wait = Serial.read();
    routine=Serial.read();
    pwm1=Serial.read();
    pwm2=Serial.read();
  }

 
  if (routine == 2) {
    i=1;
    while (i <= 15) {
      unsigned long currentMillis = millis();
      if (currentMillis - previousMillis >= timeLed ) {
        analogWrite(9, 0); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, 0); 
//        Serial.print('<');
//        Serial.print(i);  //Identify red light??
//        Serial.print(',');
//        Serial.print(millis());
//        Serial.print('>');
//        Serial.println();
        analogWrite(9, pwm1 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, 0); // INFRARED PWM = 2 Pin 10!!! protoboard 37 extremoamarillo
        pwm1 = pwm1 + 1;
        i=i+1;
        previousMillis = currentMillis;
      }
      delay(50);
      Serial.print('<');
      Serial.print(analogRead(A0));
      Serial.print(',');
      Serial.print(millis());
      Serial.print('>');
      Serial.println();
    }
   
    while (wait != 3) {
    wait = Serial.read();
    }
    analogWrite(9, 0 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
    analogWrite(10, 1);
    i = 1;
    unsigned long currentMillis = millis();
    previousMillis = currentMillis;
    while (i <= 5) {
      unsigned long currentMillis = millis();
      if (currentMillis - previousMillis >= timeLed ) {
         i = i + 1;
         analogWrite(9, 0 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, 0);
//        Serial.print('<');
//        Serial.print(i);  //Identify red light??
//        Serial.print(',');
//        Serial.print(millis());
//        Serial.print('>');
//        Serial.println();
        analogWrite(9, 0 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, pwm2);
        pwm2=pwm2+1;
        // INFRARED PWM = 2 Pin 10!!! protoboard 37 extremoamarillo
       
        previousMillis = currentMillis;
      }
      delay(30);
      Serial.print('<');
      Serial.print(analogRead(A0));
      Serial.print(',');
      Serial.print(millis());
      Serial.print('>');
      Serial.println();
    }
    wait = 0;
    routine=0;
  }
  
  else if (routine==1) {
    i=0;
    while(wait==1){
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= timeLed) {
      // Encendemos o apagamos el LED
      if (i % 2 == 1) {
        delay(30); // delay so Matlab can read it and there is nothing stored in the buffer
        Serial.print('<');
        Serial.print('0');  //Identify infrared light
        Serial.print(',');
        Serial.print(millis());
        Serial.print('>');
        Serial.println();
        analogWrite(9, 0 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, pwm2); // INFRARED PWM = 2 Pin 10!!! protoboard 37 extremoamarillo
        // Almacenamos el último momento en que hemos actuado
        i = i + 1;
      }

      else {
        delay(30);
        Serial.print('<');
        Serial.print('1');  //Identify red light
        Serial.print(',');
        Serial.print(millis());
        Serial.print('>');
        Serial.println();
        analogWrite(9, pwm1 ); // RED PWM = 9 Pin 9!!!!! protoboard29 centro
        analogWrite(10, 0); // INFRARED PWM = 2 Pin 10!!! protoboard 37 extremoamarillo
        // Almacenamos el último momento en que hemos actuado
        i = i + 1;

      }
      previousMillis = currentMillis;
    }
    
    delay(30);
    Serial.print('<');
    Serial.print(analogRead(A0));
    Serial.print(',');
    Serial.print(millis());
    Serial.print('>');
    Serial.println();
  }
  }

}
