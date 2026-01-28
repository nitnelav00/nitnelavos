/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */

/**
 * L'interface qui sert à définir la structure d'une application
 */
interface GUIApp {
  String getname();
  PVector setup(int id, StringList arguments);
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus);
  void draw(PGraphics pg, float width, float height);
}

/**
 * Une petite application simple pour tester si les fenêtres s'affichent bien
 */
class AppTest implements GUIApp {

  float x, y;
  int id;

  PVector setup(int id, StringList arguments) {
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

  void draw(PGraphics pg, float width, float height) {
    pg.background(0);

    pg.fill(255);
    pg.circle(sin(millis() / 1000.) * width/2. + width/2., cos(millis() / 1000.) * height/2. + height/2., 20);

    pg.fill(255, 0, 0);
    pg.circle(x, y, 60);
  };
}

/**
 * Juste un test pour essayer de faire une application qui a besoin de beaucoups de performances
 */
class Fractal implements GUIApp { // Ne fonctionne pas encore
  int id;
  int SPEED=8000; // nombres d'itérations par frames
  int a=0;
  int pixelsCalcules=0;
  int espacesEntrePixels=10;
  
  int PRECISION=800;
  int DIST = 200;
  float randomColor = 0;

  String getname() {
    return "Fractal";
  };
  
  PVector pow2i(PVector v){ // Fonction z**2 pour z un nombre complexe
  return new PVector(
    v.x*v.x - v.y*v.y,
    v.x*v.y*2.0
    );
}

  PVector setup(int id, StringList arguments) {
    this.id = id;
    if (espacesEntrePixels <= 0) // il ne peux pas y avoir 0 ou moins espaces entre les pixels
      espacesEntrePixels = 1;
    else while ((400*400)%espacesEntrePixels!=1)  // Pour être sûr que tous les pixels seront dessinés
      espacesEntrePixels+=1;
    randomColor = random(0., 12.);
    return new PVector(400, 400);
  };

  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) { // Rien
  };

  void draw(PGraphics pg, float width, float height) {
    if (width*height <= pixelsCalcules) // Si la fractale a finie de se faire dessiner inutile de continuer
      return;
    float x, y;
    pg.strokeCap(PROJECT);
    
    for (int i=0; i<SPEED; i++) {
      x = a%width;
      y = a/height;
      PVector uv = new PVector(x*3./width - 1.8,y*3./height -1.5);
      PVector b = uv.copy();

      float count = 0;
      for (int j=0; j<PRECISION; j++) {
        b = pow2i(b);
        b.add(uv);
        if (b.dot(b) > DIST)
          break;
        count += 1.;
      }

      pg.stroke(noise(count+1.4 + randomColor)*255, noise(count+0.1 + randomColor)*255, noise(count+3.1 + randomColor)*255, 255);
      pg.point(x, y);
      a+=espacesEntrePixels;
      a %= width*height;
      pixelsCalcules+=1;
    }
  };
}
