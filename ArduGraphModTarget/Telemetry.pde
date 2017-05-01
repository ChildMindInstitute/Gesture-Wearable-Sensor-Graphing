/*
 ArduGraph
 Telemetry
*/

public void OPEN(int theValue)
{
  //open serial port
  if (initCom == 1)
  {  
     InitSerial(comSelected); // initialize the serial port selected
     initCom=2;
  }   
}


public void CLOSE(int theValue)
{
  if(initCom == 2)
  {
    serial.stop();
    initCom = 1;
  }  
}


public void CLEAR(int theValue)
{  
    clearGraph();
}  

void clearGraph()
{
  for (int i=0; i<posX-1; i++)  
     {
      VideoBuffer1[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer2[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer3[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer4[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer5[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer6[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer7[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
      VideoBuffer8[i] = -((max+min)/2)*height/(abs(max)+abs(min)); 
     }   
}  

void processSerialData()
{     
/*
  // Expand array size to the number of bytes you expect
  byte[] inBuffer = new byte[50];
  while (serial.available() > 0) 
  {
    inBuffer = serial.readBytes();
    serial.readBytes(inBuffer);
    if (inBuffer != null) 
    {
      receiveString = new String(inBuffer);
      println(receiveString);
    }
  }
  
  */
  while (serial.available() > 0)  
       receiveString = serial.readStringUntil(10);  //10 is linefield   
  println(receiveString);
  serial.clear();     
  if (receiveString != null)
      ParseString();
     
}


void ParseString()
{
    int index = receiveString.indexOf("set:");
    float num=0;
    
    if (index==0)
    {
        //set arrival      
        String temp = receiveString.substring(4, receiveString.length());  // substring data
       
        //String[] q = splitTokens(receiveString, "min:");
            
        String[] command = split(temp, ',');
        println(command.length);
        println(command[0]);
        
        if (command.length == 3) //one label
        {
          if ( (max>min) && abs(max)< 2000)
          {
            min = Integer.parseInt(command[0]);
            max = Integer.parseInt(command[1]);
          }
          label1 = trim(command[2]); // eliminate \r\n chars 
          println("min=" + min + " max=" + max + " lb1=" + label1 + " lb2=" + label2 + " lb3=" + label3);
         }        
        
        if (command.length == 4) //two label
        {
          if ( (max>min) && abs(max)< 2000)
          {
            min = Integer.parseInt(command[0]);
            max = Integer.parseInt(command[1]);
          }
          label1 = command[2];
          label2 = trim(command[3]);// eliminate \r\n chars 
          println("min=" + min + " max=" + max + " lb1=" + label1 + " lb2=" + label2 + " lb3=" + label3);
         }  
          
        
        if (command.length == 5)  //three label
        {
          if ( (max>min) && abs(max)< 2000)
          {
            min = Integer.parseInt(command[0]);
            max = Integer.parseInt(command[1]);
          }
          label1 = command[2];
          label2 = command[3];
          label3 = trim(command[4]);  // eliminate \r\n chars
          println("min=" + min + " max=" + max + " lb1=" + label1 + " lb2=" + label2 + " lb3=" + label3);
         }       
         
        if (command.length > 5)  //mucho label
        {
          if ( (max>min) && abs(max)< 2000)
          {
            min = Integer.parseInt(command[0]);
            max = Integer.parseInt(command[1]);
          }
          label1 = command[2];
          label2 = command[3];
          label3 = command[4];
          label4 = command[5];
          label5 = command[6];
          label6 = command[7];
          label7 = command[8];  // eliminate \r\n chars
          label8 = trim(command[9]);  // eliminate \r\n chars
          println("min=" + min + " max=" + max + " lb1=" + label1 + " lb2=" + label2 + " lb3=" + label3 + " lb4=" + label4 + " lb5=" + label5 + " lb6=" + label6 + " lb7=" + label7 + " lb8=" + label8);
          //println("min=" + min + " max=" + max + " lb1=" + label1 + " lb2=" + label2 + " lb3=" + label3);
         }   
    }
    else 
    {            
        String[] data = split(receiveString, ',');
        if (data.length == 1)
        {
          //try  { num = Integer.parseInt(trim(data[0])); }
          try { num = Float.parseFloat(trim(data[0])); }          
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value1 = constrain(num, min, max);
          numOfGraph=1;
        }
        if (data.length == 2)
        {
          //try  { num = Integer.parseInt(trim(data[0])); }
          try { num = Float.parseFloat(trim(data[0])); }          
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value1 = constrain(num, min, max);          
          //try  { num = Integer.parseInt(trim(data[1])); }
          try { num = Float.parseFloat(trim(data[1])); }          
          catch  (NumberFormatException e) { println("Error:" + e); } 
          Value2 = constrain(num, min, max);
          numOfGraph=2;   
        }
        if  (data.length == 3)
        {
          //try  { num = Integer.parseInt(trim(data[0])); }
          try { num = Float.parseFloat(trim(data[0])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }   
          Value1 = constrain(num, min, max);          
          //try  { num = Integer.parseInt(trim(data[1])); }
          try { num = Float.parseFloat(trim(data[1])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value2 = constrain(num, min, max);          
          //try  { num = Integer.parseInt(trim(data[2])); }
          try { num = Float.parseFloat(trim(data[2])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value3 = constrain(num, min, max);          
          numOfGraph=3;
        }       
           if  (data.length > 3)
        {
          //try  { num = Integer.parseInt(trim(data[0])); }
          try { num = Float.parseFloat(trim(data[0])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }   
          Value1 = constrain(num, min, max);          
          //try  { num = Integer.parseInt(trim(data[1])); }
          try { num = Float.parseFloat(trim(data[1])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value2 = constrain(num, min, max);          
          //try  { num = Integer.parseInt(trim(data[2])); }
          try { num = Float.parseFloat(trim(data[2])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value3 = constrain(num, min, max);  
          try { num = Float.parseFloat(trim(data[3])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value4 = constrain(num, min, max); 
          try { num = Float.parseFloat(trim(data[4])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value5 = constrain(num, min, max); 
          try { num = Float.parseFloat(trim(data[5])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value6 = constrain(num, min, max); 
          try { num = Float.parseFloat(trim(data[6])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value7 = constrain(num, min, max); 
          try { num = Float.parseFloat(trim(data[7])); }           
          catch  (NumberFormatException e) { println("Error:" + e); }
          Value8 = constrain(num, min, max);         
          numOfGraph=8;
        }           
  }
}  
  

void InitSerial(float portValue) 
{
  // initialize the serial port selected in the listBox  
  println("initializing serial " + int(portValue) + " in serial list"); // for debugging
  // grab the name of the serial port
  String portPos = Serial.list()[int(portValue)]; 
  // initialize the port
  serial = new Serial(this, portPos, 115200);
//    serial = new Serial(this, portPos, 9600); 
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  serial.bufferUntil('\n');
  println("Done init " + portPos);
  // initialized com port flag
  initCom=2;  
}
