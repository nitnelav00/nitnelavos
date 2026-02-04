

class Cours_13 implements GUIApp {
  
  int r = 0, g = 0, b = 0;
  Bouton rUp, rDown, gUp, gDown, bUp, bDown;
  String rgb;
  
  String getname() {
    return "Cours 13";
  }
  
  int id;
  PVector setup(int id, StringList arguments){
    this.id = id;
    
    int width = 400;
    int height = 400;
    
    int t = 25; // taille du bouton
  rUp = new Bouton(width / 2 - 2 * t, height / 2 - t, t, color(255, 0, 0), '+');
  rDown = new Bouton(width / 2 - 2 * t, height / 2 + t, t, color(255, 0, 0), '-');
  gUp = new Bouton(width / 2, height / 2 - t, t, color(0, 255, 0), '+');
  gDown = new Bouton(width / 2, height / 2 + t, t, color(0, 255, 0), '-');
  bUp = new Bouton(width / 2 + 2 * t, height / 2 - t, t, color(0, 0, 255), '+');
  bDown = new Bouton(width / 2 + 2 * t, height / 2 + t, t, color(0, 0, 255), '-');
  
  return new PVector(width, height);
  }
  
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) {
    if (mousePressed && focus) {
      if (rUp.sourisDedans(mouse)) {
        r++;
      } else if (rDown.sourisDedans(mouse)) {
        r--;
      } else if (gUp.sourisDedans(mouse)) {
        g++;
      } else if (gDown.sourisDedans(mouse)) {
        g--;
      } else if (bUp.sourisDedans(mouse)) {
        b++;
      } else if (bDown.sourisDedans(mouse)) {
        b--;
      }
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
    }
  }
  void draw(PGraphics pg, float width, float height) {
    pg.background(r, g, b);
    pg.noStroke();
    pg.fill(0);
    pg.rectMode(CORNER);
    pg.rect(10, 10, width - 20, 40);

    rgb = "color(" + r + ", " + g + ", " + b + ")";
    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.text(rgb, width / 2, 30);

    rUp.dessiner(pg);
    rDown.dessiner(pg);
    gUp.dessiner(pg);
    gDown.dessiner(pg);
    bUp.dessiner(pg);
    bDown.dessiner(pg);
  }
}

class Bouton {
  int x;
  int y;
  int t;
  color coul;
  char signe;
  Bouton(int _x, int _y, int _t, color _coul, char _signe){
    x = _x;
    y = _y;
    t = _t;
    coul = _coul;
    signe = _signe;
  }
  
  boolean sourisDedans(PVector mouse){
    return mouse.x >= x && mouse.x <= x + t && mouse.y >= y && mouse.y <= y + t;
  }
  
  void dessiner(PGraphics pg){
    pg.rectMode(CORNER);
    pg.fill(coul);
    pg.rect(x, y, t, t);
  }
}
