
PImage fondFlappy;
PImage solFlappy;
PImage tuyauFlappy;
PImage joueurFlappy;

class Tuyau {
  PVector pos;
  int centreTuyau;
  Rect haut;
  Rect bas;
  Tuyau(float positionDepart) {
    centreTuyau = -tuyauFlappy.height / 2;
    pos = new PVector(positionDepart, centreTuyau / 2);
    haut = new Rect(pos.x + 5, pos.y, tuyauFlappy.width - 10, -centreTuyau - 55);
    bas = new Rect(pos.x, pos.y -centreTuyau + 55, tuyauFlappy.width - 10, -centreTuyau - 55);
    pos.y = randomGaussian() * centreTuyau/4 + centreTuyau/2;
    haut.setY(pos.y);
    bas.setY(pos.y -centreTuyau + 55);
  }
  boolean update(float vitesse, float width){
    pos.x -= vitesse;
    boolean ajouter = false;
    if (pos.x < -tuyauFlappy.width) {
      pos.x = width;
      pos.y = constrain(randomGaussian(), -1, 1) * centreTuyau/4 + centreTuyau/2;
      haut.setY(pos.y);
      bas.setY(pos.y -centreTuyau + 55);
      ajouter = true;
      
    }
    haut.x = bas.x = pos.x + 5;
    return ajouter;
  }
  
  void draw(PGraphics pg) {
    pg.image(tuyauFlappy, pos.x, pos.y);
    pg.fill(255, 0, 0, 128);
    haut.draw(pg);
    bas.draw(pg);
  }
  
  boolean collision(Rect joueur) {
    return haut.collision(joueur) || bas.collision(joueur);
  }
}

class Flappy implements GUIApp {
  int id;
  float position;
  int width;
  int height;
  Tuyau tuyau0;
  Tuyau tuyau1;
  int score;
  
  Rect joueur;
  float vy;
  String getname(){
    return "Flappy potato   Score : " + score;
  }
  IntList setup(int id, StringList arguments) {
    width = 360;
    height = 640;
    score = 0;
    joueur = new Rect(20, height/2, joueurFlappy.width, joueurFlappy.height, true);
    position = 0; vy = 0;
    tuyau0 = new Tuyau(width);
    tuyau1 = new Tuyau(width + width/1.7);
    this.id = id;
    return new IntList(width, height);
  }
  
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus){
    position -= 1;
    joueur.y += vy;
    vy += .2;
    
    if (click) {
      vy = -4;
    }
    if (tuyau0.update(1,width)) score++;
    if (tuyau1.update(1,width)) score++;
  }
  
  void draw(PGraphics pg, float width, float height){
    pg.image(fondFlappy, (position*.7)%width,0);
    pg.image(fondFlappy, (position*.7)%width + width,0);
    pg.push();
      pg.imageMode(CENTER);
      pg.translate(joueur.getX(),joueur.getY());
      pg.rotate(constrain(vy/4, -QUARTER_PI, HALF_PI-.2));
      pg.image(joueurFlappy,0,0);
    pg.pop();
    
    tuyau0.draw(pg);
    tuyau1.draw(pg);
    if (tuyau0.collision(joueur) || tuyau1.collision(joueur)){
      position = 0;
      tuyau0 = new Tuyau(width);
      tuyau1 = new Tuyau(width + width/1.7);
      score = 0;
    }
    
    pg.image(solFlappy, position%width,0);
    pg.image(solFlappy,position%width + width,0);
  }
}
