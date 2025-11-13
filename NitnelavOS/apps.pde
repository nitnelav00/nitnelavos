
// === Une interface pour créer plusieurs applications et pouvoir les mettres dans une fenêtre ===
interface GUIApp {
  String getname();
  PVector setup(int id);
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus);
  void draw(PGraphics pg, PVector taille);
}

// ====================================
// une application simple pour tester
// ====================================
class AppTest implements GUIApp {

  float x, y;
  int id;

  PVector setup(int id) {
    this.id = id;
    return new PVector(600, 600);
  }
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) {
    x = mouse.x;
    y = mouse.y;
  };

  String getname() {
    return "AppTest " + str(id) + " : " + str(x);
  }

  void draw(PGraphics pg, PVector taille) {
    pg.background(0);

    pg.fill(255);
    pg.circle(sin(millis() / 1000.) * taille.x/2. + taille.x/2., cos(millis() / 1000.) * taille.y/2. + taille.y/2., 20);

    pg.fill(255, 0, 0);
    pg.circle(x, y, 60);
  };
}
