/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */

SystemFichiers fichiers;

ArrayList<Window> fenetres; // Liste des fenêtres actives
ArrayList<Processus> process;
boolean click = false; // Lire le front montant d'un click de souris
IntList aDetruire; // Liste des fenêtres à détruire
IntList paDetruire; // Liste des processus à détruire
PGraphics fondEcran;

float scaleX;
float scaleY;
float scaleMin;

boolean[] touchesAppuyes; // les touches appuyées
boolean touche;
char lettreAppuyee = 65535; // les touches appuyées
boolean lettre;
static int compteur = 0;

void setup() {
  size(1920, 1080);
  //fullScreen();
  scaleX = sqrt(width/1920.);
  scaleY = sqrt(height/1080.);
  scaleMin = min(scaleX, scaleY);

  aDetruire = new IntList();
  paDetruire = new IntList();

  fenetres = new ArrayList<Window>();
  process = new ArrayList<Processus>();

  touchesAppuyes = new boolean[1024];

  PImage fondEcranImage;
  fondEcranImage = loadImage("img1.jpeg");
  fondEcran = createGraphics(width, height);
  fondEcran.beginDraw();
  fondEcran.image(fondEcranImage, 0, 0, width, height);
  fondEcran.endDraw();

  fichiers = new SystemFichiers("nitnelavOS");
  redraw();
}

void draw() {
  if (fenetres.size() < 1)
    creerApp("Terminal", null);

  if (aDetruire.size() > 0) {
    fenetres.remove(aDetruire.get(0));
    aDetruire.remove(0);
    redraw();
  }
  if (paDetruire.size() > 0) {
    process.remove(paDetruire.get(0));
    paDetruire.remove(0);
  }

  for (int i = process.size() - 1; i>=0; i--) {
    process.get(i).update();
  }
  int focus = -1;
  for (int i = 0; i<fenetres.size(); i++) {
    fenetres.get(i).update(focus == -1 && fenetres.get(i).sourisDansFenetre());
    if (fenetres.get(i).sourisDansFenetre() && focus == -1)
      focus = i;
  }


  if (focus != -1 && focus != 0 && focus < fenetres.size()) {
    Window temp = fenetres.get(focus);
    fenetres.remove(focus);
    fenetres.add(0, temp);
  }


  for (int i = fenetres.size() - 1; i>=0; i--) {
    fenetres.get(i).draw();
  }

  windowTitle("Programme de Valentin, FPS:" + nf(frameRate, 0, 1));
  // menu();

  // Remettre les variables à 0 pour n'avoir que le front montant (le momment où on appuie)
  click = false;
  touchesAppuyes = new boolean[1024];
  lettreAppuyee = 65535;
  touche=false;
}

void redraw() {
  background(14);
  image(fondEcran, 0, 0);
}

void mousePressed(MouseEvent event) {
  if (event.getButton() == 37)
    click = true;
}

void keyPressed() {
  lettreAppuyee = key;
  touchesAppuyes[keyCode] = true;
  touche=true;
}

void detruire(int id) {
  for (int i = 0; i<fenetres.size(); i++) {
    if (fenetres.get(i).id == id)
      aDetruire.append(i);
  }
}

void pdetruire(int id) {
  for (int i = 0; i<process.size(); i++) {
    if (process.get(i).getId() == id)
      paDetruire.append(i);
  }
}

boolean mouseInRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}
