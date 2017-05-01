/*
 ArduGraph
 Graphic Interface
*/


void InitButton()
{
  controlP5.addButton("OPEN")
    // .setValue(0)
     .setPosition(400,50)
     .setSize(90,22)
     .setColorBackground(c_blue)
     ;  
     
  controlP5.addButton("CLOSE")
     .setPosition(400,85)
     .setSize(90,22)
     .setColorBackground(c_blue)     
     ;       

  controlP5.addButton("CLEAR")
     .setPosition(400,120)
     .setSize(90,22)
     .setColorBackground(c_blue)     
     ;         
}


void graphLabel()
{
  //Draw Grid for Roll Graph
  textSize(20); 
  fill(c_azure);
  //text(max, 10, posY-height/2); 
  //if ( (max+min) < 10 )
  //    text(float(max+min)/2.0, 10, posY);
  //else    
  //    text((max+min)/2, 10, posY);
  //text(min, 10, posY+height/2);   
  
   text("Angle", 10, posY-height/2); 
  if ( (max+min) < 10 )
     text("Temperature", 10, posY);
  else    
      text("Temperature", 10, posY);
  text("Proximity", 10, posY+height/2);  
  fill(c_yellow);
  textAlign(RIGHT);
  
  fill(c_burg); 
  text(label8, posX, posY-height/2-5);
  fill(c_magenta); 
  text(label7, posX-15*(label8.length()), posY-height/2-5); 
  fill(c_orange);
  text(label6, posX-15*(label7.length()+label8.length()), posY-height/2-5);   
  fill(c_cyan);
  text(label5, posX-15*(label6.length()+label7.length()+label8.length()), posY-height/2-5);   
  fill(c_purple);
  text(label4, posX-15*(label5.length()+label6.length()+label7.length()+label8.length()), posY-height/2-5);   
  fill(c_green);
  text(label3, posX-15*(label4.length()+label5.length()+label6.length()+label7.length()+label8.length()), posY-height/2-5);   
  fill(c_red);
  text(label2, posX-15*(label3.length()+label4.length()+label5.length()+label6.length()+label7.length()+label8.length()), posY-height/2-5);   
  fill(c_yellow);
  text(label1, posX-15*(label2.length()+label3.length()+label4.length()+label5.length()+label6.length()+label7.length()+label8.length()), posY-height/2-5);   
  strokeWeight(2);  
  line( posX, posY-height/2, 10, posY-height/2);  
  line( posX, posY+height/2, 10, posY+height/2); 
  textAlign(LEFT);
}



void graphGrid()
{
  //Draw Grid for Roll Graph
  //
  stroke(c_grey);
  strokeWeight(1);
  for (int i=0; i<5; i++)
  {
      // dot line  
      line( posX, posY-i*(height/10), 10, posY-i*(height/10));  
  } 
  for (int i=0; i<5; i++)
  {
      // dot line  
      line( posX, posY+i*(height/10), 10, posY+i*(height/10));  
  }   
}



void graphRoll(float inData, int[] graphBuffer, color c_color, int dataNum)
{
  // For each frame the buffer that contains the older samples are shifted by one position
  // refresh data only is new serial data is arrived  
  
  //manually add base vals so we can fil
  int baseVal = 0;
  if(dataNum == 1) baseVal = 600;
  if(dataNum == 2) baseVal = 600;
  if(dataNum == 3) baseVal = -250;
  if(dataNum == 4) baseVal = 150 + 60;
  if(dataNum == 5) baseVal = 150 + 60*2;
  if(dataNum == 6) baseVal = 150 + 60*3;
  if(dataNum == 7) baseVal = 150 + 60*4;
  if(dataNum == 8) baseVal = 150;
  
  
  if (timeOnce ==1)
  {
    for(int r = 0; r<10; r++){  //SPEED UP GRAPH
    
    for (int i=0; i<posX-1; i++){  
      graphBuffer[i] = graphBuffer[i+1];
    }
    
    }
  }    
    
    //TEST
  int baseValBuff = (int)map(baseVal, min, max, -height/2, height/2);  
   
  // Store the new entry data
  graphBuffer[posX-1] = (int)map(inData, min, max, -height/2, height/2);  
  stroke(c_color);
  strokeWeight(2);
  // plot the graph that goes from right to left
  //for(int i = 0; i<50; i++){  //SPEED UP GRAPH
  for (int x=posX; x>10; x--){
    line( x, posY-graphBuffer[x-1], x+1, posY-graphBuffer[x]);
   
       //TEST , only when even ... or div by 5
    if(x % 10 == 0 ) line( x, posY - baseValBuff, x+1, posY - baseValBuff); 
    
  }
    

    
  //fill between value and minimum possible value
  /*
  fill(c_color);  
  beginShape();
    vertex(posX, posY-graphBuffer[posX-1]);
    vertex(posX+1, posY-graphBuffer[posX]);
    vertex(posX+1, baseVal);
    vertex(posX, baseVal);
  endShape(CLOSE);
  */

    
  //}
    
  noStroke();
}


void InitComDropdown()
{
  // Initialize portCommList 
  int posX = 20;
  int posY = 70;
  PortsList = controlP5.addDropdownList("portComList",posX,posY,120,84);    
  //Set the background color of the list (you wont see this though).
  PortsList.setBackgroundColor(color(150));
  //Set the height of each item when the list is opened.
  PortsList.setItemHeight(22);
  //Set the height of the bar itself.
  PortsList.setBarHeight(22);
  //Set the lable of the bar when nothing is selected.
  PortsList.captionLabel().set("COM port");
  //Set the top margin of the lable.
  PortsList.captionLabel().style().marginTop = 3;
  //Set the left margin of the lable.
  PortsList.captionLabel().style().marginLeft = 3;
  //Set the top margin of the value selected.
  PortsList.valueLabel().style().marginTop = 3;
  //Store the Serial ports in the string comList (char array).
  comList = serial.list();
  
  println(comList);
  if (comList.length!=0)
  { 
    //We need to know how many ports there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
    String comlist = join(comList, ",");
    //We also need how many characters there is in a single port name, we´ll store the chars here for counting later.
    String COMlist = comList[0];
    //Here we count the length of each port name.
    int size2 = COMlist.length();
    //Now we can count how many ports there are, well that is count how many chars there are, so we will divide by the amount of chars per port name.
    int size1 = comlist.length() / size2;
    //Now well add the ports to the list, we use a for loop for that. How many items is determined by the value of size1.
    for(int i=0; i< size1; i++)  //con dispositivo BT errore perchè troppe porte
//    for(int i=0; i< 7; i++) //se sono disponibili più di 9 porte
    {
      //This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
      PortsList.addItem(comList[i],i);
    }
  }  
  //Set the color of the background of the items and the bar.
  PortsList.setColorBackground(color(150));
  //Set the color of the item your mouse is hovering over.
  PortsList.setColorActive(color(255,128));
}


// apre la seriale appena selezionata
void controlEvent(ControlEvent theEvent) 
{

  //select com from list 
  if(theEvent.isGroup() && theEvent.name().equals("portComList"))   
  { 
    comSelected = int(theEvent.group().value());
    println("Select portComList " + comSelected); // for debugging
    initCom=1;
    //InitSerial(theEvent.group().value()); // initialize the serial port selected    
  }
}

