/*
 ArduGraph V2.0
 
 by Nikhilesh Prasannakumar
 Processing v3.0b3
 17 August 2015
 
 An open-source easy to use serial graph monitor for Arduino.
  
 Based on ArduGraph V1.0 by Mirco Segatello 
 http://www.open-electronics.org/guest_projects/ardugraph/
  
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

color c_yellow = color(200, 200, 20);  //value1
color c_green = color(30, 120, 30);    //value3
color c_red = color(250, 30, 30);      //value2
color c_azure = color(170, 180, 180);  //text
color c_blue = color(45, 80, 150);     //button
color c_grey = color(128,128,128);     // line

// Variables for displayng data
int[] VideoBuffer1;
int[] VideoBuffer2;
int[] VideoBuffer3;

int initCom = 0;  //0=nocom 1=close 2=open
int comSelected = 0;
String status;

int DisplayWidth = 520; //screenWidth
int DisplayHeight = 500; //screenHeight

int posX = 510;   //posX graph (center graph)
int posY = 330;   //posY graph (left graph)
int height = 300;  //height graph
// length graph is from 0 to posX0

// Default set for graph
String receiveString;
String setString="";
int min=0;
int max=1023;
int numOfGraph=1;
float Value1=0;
float Value2=0;
float Value3=0;
String label1="---";
String label2="---";
String label3="---";

int timeOnce=0;


void setup() 
{
  size(520, 500); 
  ImageIcon myicon = new ImageIcon(loadBytes("ArduGraph.png"));
  frame.setIconImage(myicon.getImage()); 
  
//  frameRate(20);  //Refresh graph rate
  smooth(); // smoothed shapes looks better!

  controlP5 = new ControlP5(this);
  ControlFont fonT = new ControlFont(createFont("Arial bold",15),15); 
  controlP5.setFont(fonT); 
  InitComDropdown();  
  InitButton();
  VideoBuffer1 = new int[width];
  VideoBuffer2 = new int[width];
  VideoBuffer3 = new int[width];
  clearGraph();  
}

void draw() 
{
  background(255);
  
  if (initCom==0) 
    status = "no COM selected";
  else if (initCom==1)
    status = "COM close";  
  else if (initCom==2)
    status = "COM open";  
  
  textFont(createFont("Arial bold",24));  
  fill(c_red);
  stroke(255);
  text("BeyonDuino Weather Station", 20, 30);

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
 
  
  if (initCom==2) 
      if (serial.available() > 0)    
      {   
          processSerialData();  
          timeOnce=1;
      }  
    
}