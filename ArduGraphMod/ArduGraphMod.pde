import controlP5.*;

/*
 ArduGraph V1.0
 
ArduGraph is open-source easy to use serial graph monitor for Arduino.
  
 by Mirco Segatello 
 Processing Ver2.2.1 
 date: june 2015
  
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License Creative Commons  BY-NC-SA
 as published by the Free Software Foundation, see <http://creativecommons.org/licenses/by-nc-sa/3.0/>    
*/

import controlP5.*;              //import the Serial, and controlP5 libraries.
import processing.serial.*;
import javax.swing.ImageIcon;    // for ICON BAR image
 
ControlP5 controlP5;             //Define the variable controlP5 as a ControlP5 type.
DropdownList PortsList;          //Define the variable ports as a Dropdownlist.
Serial serial;                   //Define the variable port as a Serial object.
String[] comList;                //A string to hold the ports in.
/*
color c_yellow = color(200, 200, 20);  //value1
color c_green = color(30, 120, 30);    //value3
color c_red = color(250, 30, 30);      //value2

color c_purple = color(128, 0, 255);      //value4
color c_cyan = color(0, 255, 255);      //value5
color c_orange = color(255, 128, 0);      //value6
color c_magenta = color(255, 0, 255);      //value7
color c_burg = color(128, 0, 64);      //value8

color c_azure = color(170, 180, 180);  //text
color c_blue = color(45, 80, 150);     //button
color c_grey = color(128,128,128);     // line
*/
color c_yellow = color(110, 110, 110);  //value1 pith
color c_green = color(30, 120, 30);    //value3 proximity
color c_red = color(40, 40, 40);      //value2 roll

color c_purple = color(148, 62, 15);      //value4 obj1
color c_cyan = color(118, 78, 44);      //value5  obj2
color c_orange = color(177, 151, 21);      //value6  obj3
color c_magenta = color(134, 161, 91);      //value7  obj4
color c_burg = color(128, 0, 64);      //value8  amb

color c_azure = color(170, 180, 180);  //text
color c_blue = color(45, 80, 150);     //button
color c_grey = color(128,128,128);     // line

// Variables for displayng data
int[] VideoBuffer1;
int[] VideoBuffer2;
int[] VideoBuffer3;
int[] VideoBuffer4;
int[] VideoBuffer5;
int[] VideoBuffer6;
int[] VideoBuffer7;
int[] VideoBuffer8;

int initCom = 0;  //0=nocom 1=close 2=open
int comSelected = 0;
String status;

int DisplayWidth = 1200; //screenWidth
int DisplayHeight = 900; //screenHeight

int posX = 1180;   //posX graph (center graph)
int posY = 500;   //posY graph (left graph)
int height = 450;  //height graph
// length graph is from 0 to posX0

// Default set for graph
String receiveString;
String setString="";
int min=0;
int max=900;
int numOfGraph=8;
int thermOffset = 50;
float Value1=0;
float Value2=0;
float Value3=0;
float Value4=0;
float Value5=0;
float Value6=0;
float Value7=0;
float Value8=0;
float Value9=0;
float Value10=0;
float Value11=0;
String label1="Pitch";
String label2="Roll";
String label3="Proximity";
String label4="Therm1";
String label5="Therm2";
String label6="Therm3";
String label7="Therm4";
String label8="Ambient";

int timeOnce=0;

void setup() 
{
  size(1200, 900); 
   textSize(16);
  ImageIcon myicon = new ImageIcon(loadBytes("ArduGraph.png"));
  frame.setIconImage(myicon.getImage()); 
  
//  frameRate(20);  //Refresh graph rate
  smooth(); // smoothed shapes looks better!

  controlP5 = new ControlP5(this);
  ControlFont fonT = new ControlFont(createFont("Arial bold",20),20); 
  //controlP5.setControlFont(fonT); 
 
  InitComDropdown();  
  InitButton();
  VideoBuffer1 = new int[width];
  VideoBuffer2 = new int[width];
  VideoBuffer3 = new int[width];
  VideoBuffer4 = new int[width];
  VideoBuffer5 = new int[width];
  VideoBuffer6 = new int[width];
  VideoBuffer7 = new int[width];
  VideoBuffer8 = new int[width];
  clearGraph();  
  numOfGraph=8;
}

void draw() 
{
  background(255);
    textFont(createFont("Arial bold",24));  
  if (initCom==0) 
    status = "no COM selected";
  else if (initCom==1)
    status = "COM close";  
  else if (initCom==2)
    status = "COM open";  
  
 // textFont(createFont("Arial bold",24));  
  fill(c_red);
  stroke(255);
  text("CMI Wearables Sensor Data", 20, 30);

  textSize(16);
  fill(c_azure);
  text("Status: " + status, 180, 140);
  graphGrid(); 
  graphLabel();
  
  if (numOfGraph ==1 )
  {
        graphRoll(Value1, VideoBuffer1, c_yellow);
        fill(c_yellow);
        text(label1 + ": " + Value1, 180, 65);
        timeOnce=0;
  }      
  if (numOfGraph == 2)
  {
        graphRoll(Value1, VideoBuffer1, c_yellow);
        graphRoll(Value2, VideoBuffer2, c_red);
        fill(c_yellow);
        text(label1 + ": " + Value1, 180, 65);
        fill(c_red);
        text(label2 + ": " + Value2, 180, 90); 
        timeOnce=0;
  }      
  if (numOfGraph == 3)
  {
        graphRoll(Value1, VideoBuffer1, c_yellow);
        graphRoll(Value2, VideoBuffer2, c_red);   
        graphRoll(Value3, VideoBuffer3, c_green);
        fill(c_yellow);
        text(label1 + ": " + Value1, 180, 65);
        fill(c_red);
        text(label2 + ": " + Value2, 180, 90); 
        fill(c_green);        
        text(label3 + ": " + Value3, 180, 115);             
        timeOnce=0;
  }
  
  if (numOfGraph > 3 && numOfGraph < 15)
  {

        graphRoll( (Value1/360)*300 + 600, VideoBuffer1, c_yellow); //pitch
        graphRoll( (Value2/360)*300 + 600, VideoBuffer2, c_red);   //roll
        graphRoll(Value3 - 50, VideoBuffer3, c_green); //proximity
        
        //expand range of thermopile values so they look better
        graphRoll( (((Value4 - 65) / 40) * 280 + 150) + thermOffset   , VideoBuffer4, c_purple);
        graphRoll( (((Value5 - 65) / 40) * 280 + 150) + thermOffset*2 , VideoBuffer5, c_cyan);
        graphRoll( (((Value6 - 65) / 40) * 280 + 150) + thermOffset*3 , VideoBuffer6, c_orange);
        graphRoll( (((Value7 - 65) / 40) * 280 + 150) + thermOffset*4 , VideoBuffer7, c_magenta);
        graphRoll( (((Value8 - 65) / 40) * 280 + 150) , VideoBuffer8, c_burg);

        fill(c_yellow);
        text(label1 + ": " + Value1, 180, 65);
        fill(c_red);
        text(label2 + ": " + Value2, 180, 90); 
        fill(c_green);        
        text(label3 + ": " + Value3, 180, 115); 
  
         fill(c_purple);        
        text(label4 + ": " + Value4, 180, 140);    
        fill(c_cyan);        
        text(label5 + ": " + Value5, 180, 165);  
        fill(c_orange);        
        text(label6 + ": " + Value6, 180, 190);    
        fill(c_magenta);        
        text(label7 + ": " + Value7, 180, 215);    
        fill(c_burg);        
        text(label8 + ": " + Value8, 180, 240); 
        
        timeOnce=0;
  }   
 
  
  if (initCom==2) 
      if (serial.available() > 0)    
      {   
          processSerialData();  
          timeOnce=1;
      }  
    
}
