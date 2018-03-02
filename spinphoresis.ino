#include <sinobit.h>
#include "Wire.h"
#include "MMA8653.h"


Sinobit matrix = Sinobit();
MMA8653 accel;
double pi = 3.1415927;
int startx[8] = {4, 3, 0, -3, -4, -3, 0, 3};
int starty[8] = {0, -3, -4, -3, 0, 3, 4, 3};
double cx = 5;
double cy = 5;
double accelXStart = 0;
double accelYStart = 0;
double ax = 0;
double ay = 0;
double spinSpeed = 1;

void setup() {
  Serial.begin(9600);
  Serial.println("Sinobit is ready!");
  // set up accelerometer
  accel.begin(false, 2);

  matrix.begin();
  delay(100);
  accel.update();
  accelXStart = accel.getX();
  accelXStart = accel.getY();
  matrix.clearScreen();
  matrix.setTextWrap(false);
  pinMode(SINOBIT_BUTTON_A, INPUT);
  pinMode(SINOBIT_BUTTON_B, INPUT);
}

void loop() {
  if (!digitalRead(SINOBIT_BUTTON_A)) {
    spinSpeed *= 0.9;
  }
  if (!digitalRead(SINOBIT_BUTTON_B)) {
    spinSpeed /= 0.9;
  }
  for (int point = 0; point < 8; point++ ){
    matrix.drawRect(startx[point] + cx, starty[point] + cy, 2, 2, 1);
    matrix.drawRect(cx, cy, 2, 2, 1);
    matrix.writeScreen();
    delay(100 * spinSpeed);
    matrix.drawRect(startx[point] + cx, starty[point] + cy, 2, 2, 0);
    matrix.drawRect(cx, cy, 2, 2, 0);
    // show accelerometer readings
    accel.update();
    // note: flipped X/Y
    double ax = accel.getY() - accelYStart;
    double ay = accel.getX() - accelXStart;
    if(abs(ax) > 10){
      cx += (ax/50) * spinSpeed;
      cx = (cx < 0) ? 0 : (cx > 10) ? 10 : cx;
    }
    // Y is inverted
    if(abs(ay) > 10){
      cy -= (ay/50) * spinSpeed;
      cy = (cy < 0) ? 0 : (cy > 10) ? 10 : cy;
    }
    matrix.writeScreen();
    delay(2 * spinSpeed);

  }
}
