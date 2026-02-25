
PImage fondFlappy;
PImage solFlappy;
PImage tuyauFlappy;

class Flappy implements GUIApp {
  int id;
  int centreTuyau;
  String getname(){
    return "Flappy";
  }
  IntList setup(int id, StringList arguments) {
    int width = 360;
    int height = 640;
    centreTuyau = -tuyauFlappy.height / 2;
    this.id = id;
    return new IntList(width, height);
  }
  
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus){}
  
  void draw(PGraphics pg, float width, float height){
    pg.image(fondFlappy,0,0);
    pg.image(tuyauFlappy,0,centreTuyau);
    pg.image(solFlappy,0,0);
  }
}
