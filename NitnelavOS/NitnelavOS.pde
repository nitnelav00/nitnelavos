/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */

ArrayList<Window> fenetres; // Liste des fenêtres actives
boolean click = false; // Lire le front montant d'un click de souris
IntList aDetruire; // Liste des fenêtres à détruire

float scaleX;
float scaleY;
float scaleMin;

boolean[] touchesAppuyes; // les touches appuyées
boolean touche;
char lettreAppuyee = 65535; // les touches appuyées
boolean lettre;

void setup() {
  size(1920, 1080);
  fullScreen();
  scaleX = sqrt(width/1920.);
  scaleY = sqrt(height/1080.);
  scaleMin = min(scaleX, scaleY);

  aDetruire = new IntList();

  fenetres = new ArrayList<Window>();

  touchesAppuyes = new boolean[1024];
}

void draw() {
  background(14);
  if (fenetres.size() < 1)
    creerApp("Terminal", null);

  if (aDetruire.size() > 0) {
    fenetres.remove(aDetruire.get(0));
    aDetruire.remove(0);
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

boolean mouseInRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}
