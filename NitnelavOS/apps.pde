/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */
 
/**
 * L'interface qui sert à définir la structure d'une application
 */
interface GUIApp {
  String getname();
  PVector setup(int id);
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus);
  void draw(PGraphics pg, PVector taille);
}

/**
 * Une petite application simple pour tester si les fenêtres s'affichent bien
 */
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

class RayTracing implements GUIApp { // Ne fonctionne pas encore
  int id;
  String getname(){return "RayTracing";};
  PVector setup(int id){this.id = id; return new PVector(400,400);};
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus){};
  void draw(PGraphics pg, PVector taille){};
}
