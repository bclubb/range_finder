#include <stdio.h>


int sampleSize = 50;
int samples[50];

int pingPin = 7;

int greenPin = 2;
int redPin = 3;
int yellowPin = 4;

int nextAdd = 0;

void setup()
{
  pinMode(greenPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(redPin, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  
  int distance, sample;
  char message[50];
  for(int i = 0; i < sampleSize; i++)
  {
    sample = ping(100);
    addSample(sample, i);
  }
  distance = calcDistance();
  lightUpLEDs(distance);
  //sprintf(message, "distance: %d : sample %d", distance, sample);
  //Serial.println(message);
}

int calcDistance()
{
  // clean out all 0 then remove the top high and low then return the avg
  int validSamples = 0;
  int min, max, sample, total;
  min = 0;
  max = 0;
  for(int i = 0; i < sampleSize; i++)
  {
    sample = samples[i];
    if(sample != 0 && sample < 365)
    {
      if(min == 0 || sample < min)
      {
        min = sample;
      }
      if(max == 0 || sample > max)
      {
        max = sample;
      }
      total += sample;
      validSamples++;
    }
  }
  int value;
  if(validSamples > 2)
  {
    validSamples -= 2;
    value = (total - min - max) / validSamples;
  }
  else
  {
    value = total / validSamples;
  }
  return value;
}

int ping( int maxDistance)
{
  long duration;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // We give a short LOW pulse beforehand to ensure a clean HIGH pulse.
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);
  
  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH, (maxDistance * 58));
  // convert the time into a distance
  //inches = microsecondsToInches(duration);
  int cm = microsecondsToCentimeters(duration);
  return cm;
}

void addSample(int cm, int place)
{
  samples[place] = cm;
}

void lightUpLEDs(int cm)
{
  if(cm < 100)
  {
    digitalWrite(greenPin, HIGH);
  }
  else
  {
    digitalWrite(greenPin, LOW);
  }
  if(cm < 50)
  {
    digitalWrite(yellowPin, HIGH);
  }
  else
  {
    digitalWrite(yellowPin, LOW);
  }
  if(cm < 10)
  {
    digitalWrite(redPin, HIGH);
  }
  else
  {
    digitalWrite(redPin, LOW);
  }

}

int microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
