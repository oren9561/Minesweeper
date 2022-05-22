import java.*;
PImage[] images = new PImage[10];
PFont f;
boolean overBox = false, overSun = false, canFlag, win, lose, clicked, dif, overDif;
int numOfBombs, numOfFlags, currentNumOfBombs, min, sec, bombs;
float runtime = 0;
Value[][] cubes = new Value[16][16];
Value flagWrong, sunL, sunW, flag, cover, boom;


void setup(){
  
  //Setting values to variables----------------------------------------------------------------------------------------------------------------------------------------------
  
  overDif = false;
  dif = false;
  clicked = true;
  lose = false;
  win = true;
  canFlag = true;
  bombs = 46;
  min = 0;
  sec = 0;
  numOfBombs = 0;
  f = createFont("digital-7.ttf",16,true);
  textFont(f, 68);
  PImage flagWrong1 = loadImage("flagX.png");
  PImage boom1 = loadImage("boom.png");
  PImage cover1 = loadImage("cover.png");  
  PImage flag1 = loadImage("flag.png");
  PImage sun1 = loadImage("sun-glasses.png");
  PImage sun2 = loadImage("sun-sad.png");
  flagWrong = new Value(0,0,flagWrong1);
  boom = new Value(0,0,boom1);
  sunL = new Value(296, 59, sun2);
  sunW = new Value(296, 59, sun1);
  flag = new Value(500, 30, flag1);
  cover = new Value(0, 0, cover1);
  size(700, 800);
  frameRate(60);
  background(220);  
  for(int i=0;i<10;i++)
    images[i] = loadImage(i + ".png");
  
  //Making The 2D Array With Blanks----------------------------------------------------------------------------------------------------------------------------------------------
  
  float xt;
  float yt;
  for(int i=0;i<16;i++)
    for(int j=0;j<16;j++){
       xt = 54 + (37*j);
       yt = 118 + (40*i);
       PVector place = new PVector(j, i);
       cubes[i][j] = new Value(xt, yt, images[0], cover.getImg(), place, images[9], images[0]);
    } 
    
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}

void draw(){
  if(!lose) clock();
  numOfFlags = countFlags(cubes);
  currentNumOfBombs = numOfBombs - numOfFlags;
  if(currentNumOfBombs == 0){
    canFlag = false;
    checkWin();
  }
  else canFlag = true;
  image(sunL.getImg(), 311, 25);
  for(int i=0;i<16;i++)
    for(int j=0;j<16;j++)
       cubes[i][j].update();
  if(mouseX>54 && mouseX<646 && mouseY>118 && mouseY<758) overBox = true;
  else overBox = false;
  if(mouseX>307 && mouseX<307+sunL.getImg().width && mouseY>25 && mouseY<25+sunL.getImg().height) overSun = true;
  else overSun = false;
  if(!lose){
     fill(65);
     rect(540, 35, 80, 55);
     fill(255,0,0);
     text(currentNumOfBombs, 550, 85); 
  }
  if(win){
      for(int i=0;i<16;i++)
         for(int j=0;j<16;j++)
            cubes[i][j].setCover(false);
      fill(220);
      rect(160, 337, 385, 110);
      fill(0,255,0);
      textFont(f, 120);
      text("VICTORY", 171, 437);
      image(sunW.getImg(), 311, 25);
      if(win) lose = true;
  }
  if(!dif){
     drawDif();
     if(mouseX>400 && mouseX<628 && mouseY>35 && mouseY<90) overDif = true;
     else overDif = false;
  } 
}

void generate(){
    background(220);
    dif = true;
    runtime = millis();
    int x = int((mouseX-54)/37);
    int y = int((mouseY-118)/40);
    Value cube = cubes[y][x];
    int num;
     while(numOfBombs < bombs){
     for(int i=0;i<16;i++)
      for(int j=0;j<16;j++){
         num = floor(random(10));
         if(num>=9 && cubes[i][j].getImg() == images[0] && numOfBombs < bombs && cubes[i][j].getX() != cube.getX() && cubes[i][j].getY() != cube.getY()){
            cubes[i][j].setImg(images[9]);
            numOfBombs++; 
         }
      }
     }
     
     for(int i=0;i<16;i++)
      for(int j=0;j<16;j++){
         if(cubes[i][j].getImg()!=images[9]){
           num = cubes[i][j].checkBombs(cubes);
           cubes[i][j].setImg(images[num]);
         }
      }
    clicked = false;
}

int countFlags(Value[][] cubes){
   int num=0;
   for(int i=0;i<16;i++)
    for(int j=0;j<16;j++)
       if(cubes[i][j].getCover() == flag.getImg() && cubes[i][j].isCovered())
         num++;
   return num; 
}

void clock(){
  if(clicked) runtime = millis();
  fill(65);
  rect(60, 35, 160, 55);
  sec = (int)(((millis() - runtime)/1000) - (min*60));
  if(sec>=60){
    min++;
    sec = 0;
  }
  fill(255,0,0);
  if(min<10){
     if(sec<10)
       text("0" + min + ":" + "0" + sec, 70, 85);
     else
       text("0" + min + ":" + sec, 70, 85);
  }
  else
     if(sec<10)
       text(min + ":" + "0" + sec, 70, 85);
     else
       text(min + ":" + sec, 70, 85);
}

void drawDif(){
  textSize(35);
   fill(120);
   rect(400, 35, 228, 55);
   for(int i = 76; i<=228; i+=76)
       line(400+i, 35, 400+i, 90);   
   for(int i = 76; i<=228; i+=76){
      fill(255);   
      if(i == 76)
        text("EASY", 405, 75);
      else{
         if(i == 152)
           text("MED", 488, 75);
         else
           text("HARD", 556, 75);
      }
      
   }
   textSize(68);
}

int whatNumber(Value cube){
  int num = 1;
  for(int i=1;i<9;i++)
    if(cube.getImg() == images[i])
      num = i;
  return num;
}  

void mousePressed(){
  if(mouseButton == LEFT){
  if(overDif && !dif){
     if(mouseX>400 && mouseX<476 && mouseY>35 && mouseY<90){
        bombs = 30;
     }
     else{
         if(mouseX>476&& mouseX<552 && mouseY>35 && mouseY<90){
             bombs = 45;
         }
         else{
             bombs = 60;
         }
     }
     if(bombs!=46){
       dif = true;
       background(220);
     }
  }
   if(overBox){
       if(clicked) generate();
       int x = int((mouseX-54)/37);
       int y = int((mouseY-118)/40);
       Value cube = cubes[y][x];
       if(cube.getCover() != flag.getImg()){
       if(cube.getImg() != images[9] && cube.getImg() != images[0] && !cube.isCovered() && !lose && cube.countFlagsAround(cubes, flag.getImg()) >= whatNumber(cube)){
          PVector a = cube.uncoverAround(cubes, lose, flag.getImg()); 
          int x1 = (int)a.x;
          int y1 = (int)a.y;
          Value cube1 = cubes[y1][x1];
          if(cube1.bomb()) lose = true;
          if(lose){
              cubes[y1][x1].setImg(boom.getImg());
              for(int i=0;i<16;i++)
                for(int j=0;j<16;j++){
                   if(cubes[i][j].getImg() != images[9] && cubes[i][j].getCover() == flag.getImg())
                     cubes[i][j].setImg(flagWrong.getImg());
                   if(!(cubes[i][j].getImg() == images[9] && cubes[i][j].getCover() == flag.getImg()))
                     cubes[i][j].setCover(false);
                }
          } 
       }
       cube.setCover(false);
       if(cube.bomb() && !lose){
          cubes[y][x].setImg(boom.getImg());
          for(int i=0;i<16;i++)
            for(int j=0;j<16;j++){
               if(cubes[i][j].getImg() != images[9] && cubes[i][j].getCover() == flag.getImg())
                 cubes[i][j].setImg(flagWrong.getImg());
               if(!(cubes[i][j].getImg() == images[9] && cubes[i][j].getCover() == flag.getImg()))
                 cubes[i][j].setCover(false);
            }
          lose = true;
       }
       if(cube.getImg() == images[0])
         cube.uncover(cubes);
   }}
   else
         if(overSun){
           runtime = millis();
           setup();
         }
  }
  else{
    if(overBox){
       int x = int((mouseX-54)/37);
       int y = int((mouseY-118)/40);
       Value cube = cubes[y][x];
       if(cube.isCovered()){
         if(cube.getCover() == flag.getImg())
           cube.setCover(true, cover.getImg());
         else
           if(canFlag)
             cube.setCoverFlag(flag.getImg());
       }
     }
  }
}

void checkWin(){
   win = true;
   for(int i=0;i<16;i++)
    for(int j=0;j<16;j++)
       if(cubes[i][j].isCovered() && cubes[i][j].getCover() == cover.getImg())
         win = false;
   if(win)
     sunL.setImg(sunW.getImg());
}

void keyPressed(){
    if(key == ' ')
      setup();
}
