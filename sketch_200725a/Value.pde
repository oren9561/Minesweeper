class Value{
   PVector place;
   float x;
   float y;
   PImage img;
   PImage cover;
   PImage bomb;
   PImage empty;
   boolean covered;
   
   //Grid Cubes Constructor----------------------------------------------------------------------------------------------------------------------------------------------
   
   public Value(float x, float y, PImage img, PImage cover, PVector place, PImage bomb, PImage empty){
       this.x = x;
       this.y = y;
       this.img = img;
       this.cover = cover;
       this.place = place;
       this.bomb = bomb;
       this.covered = true;
       this.empty = empty;   }
       
   //Flag/Sun Constructor----------------------------------------------------------------------------------------------------------------------------------------------
   
   public Value(float x, float y, PImage flagOrSun){
       this.x = x;
       this.y = y;
       this.covered = false;
       this.img = flagOrSun;
   }
   
   public void update(){
       if(this.covered){
         image(this.cover, this.x, this.y);
         this.cover.resize(37, 40);
       }
       else
         image(this.img, this.x, this.y);
         this.img.resize(37, 40);
   }
   
   public void setCover(boolean a){
      this.covered = a; 
   }
   
   public void setCover(boolean a, PImage cover){
      this.covered = a; 
      this.cover = cover;
   }
   
   public PImage getCover(){
     return this.cover;
   }
   
   public void setCoverFlag(PImage flag){
      this.cover = flag;
   }
   
   public void setImg(PImage img){
     this.img = img;
   }
   
   public float getX(){
     return this.x;
   }
   
   public float getY(){
     return this.y;
   }
   
   public boolean isCovered(){
      return this.covered; 
   }
   
   public PImage getImg(){
     return this.img;
   }
   
   public boolean bomb(){
     if(this.img == this.bomb)
       return true;
     return false;
   }
   
   public int checkBombs(Value[][] cubes){
     int count=0;
     for(int i=-1;i<=1;i++)
       for(int j=-1;j<=1;j++){
          int x = int(this.place.x) + j;
          int y = int(this.place.y) + i;
          if(x > -1 && x < 16 && y > -1 && y < 16)
             if(cubes[y][x].bomb()) 
               count++;
       }
     return count;
       
   }
   
   public void uncover(Value[][] cubes){
     this.covered = false;
     if(this.img == this.empty){
       for(int i=-1;i<=1;i++)
         for(int j=-1;j<=1;j++){
            int x = int(this.place.x) + j;
            int y = int(this.place.y) + i;
            if(x > -1 && x < 16 && y > -1 && y < 16)
              if((!cubes[y][x].bomb()) && cubes[y][x].isCovered()) 
                cubes[y][x].uncover(cubes);
         }
     }
   }
   
   public int countFlagsAround(Value[][] cubes, PImage flag){
      int num = 0;
      for(int i=-1;i<=1;i++)
         for(int j=-1;j<=1;j++){
            int x = int(this.place.x) + j;
            int y = int(this.place.y) + i;
            if(x > -1 && x < 16 && y > -1 && y < 16)
                if(cubes[y][x].getCover() == flag && cubes[y][x].isCovered())
                  num++;
         }
      return num;
   }
   
   public PVector uncoverAround(Value[][] cubes, boolean lose, PImage flag){
     for(int i=-1;i<=1;i++)
         for(int j=-1;j<=1;j++){
            int x = int(this.place.x) + j;
            int y = int(this.place.y) + i;
            if(x > -1 && x < 16 && y > -1 && y < 16){
              if((!cubes[y][x].bomb()) && cubes[y][x].isCovered() && cubes[y][x].getCover() != flag){
                if(cubes[y][x].getImg() == this.empty)
                  cubes[y][x].uncover(cubes);
                else
                  cubes[y][x].setCover(false);
              }
              if(cubes[y][x].bomb() && !lose && cubes[y][x].getCover() != flag){
                 PVector a = new PVector(x,y);
                 return a;
              }
            }
         }
      return this.place;
   }
  
  
}
