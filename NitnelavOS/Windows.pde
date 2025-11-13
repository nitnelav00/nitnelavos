
static int compteur = 0;

class Window {
  PVector position; // Position de la fenètre
  PVector taille; // Taille de la fenètre
  GUIApp appli;
  boolean deplacement = false; // Savoir si la fenêtre est en train de se faire déplacer
  PGraphics affichage; // Rendu graphique de la fenetre

  PVector mouse;
  PVector pmouse;
  int id;
  // ====================================
  // Le constructeur de la fonction
  // ====================================
  Window(PVector position, GUIApp application) {

    this.appli = application;

    mouse = new PVector(0., 0.);
    pmouse = new PVector(0., 0.);

    id = compteur++;
    this.taille = appli.setup(id);

    affichage = createGraphics(int(taille.x), int(taille.y)); // Créer l'interface graphique avec la même taille que la fenètre

    if (position != null)
      this.position = position;
    else
      this.position = new PVector(width/2. - taille.x/2., height/2. - taille.y/2.);
  }

  // ====================================
  // mettre à jour la fenêtre
  // ====================================
  void update(boolean focus) {
    // if (pmouseX >= position.x && pmouseX <= position.x + taille.x && pmouseY >= position.y && pmouseY <= position.y + 22 * scaleY && click && focus)
    if (mouseInRect(position.x, position.y, taille.x, 22 * scaleY) && click && focus)
      deplacement = true;
    if (pmouseX >= position.x && pmouseX <= position.x + taille.x && pmouseY >= position.y && pmouseY <= position.y + 22 * scaleY && mousePressed && deplacement) {
      position.x += mouseX - pmouseX;
      position.y += mouseY - pmouseY;
    } else deplacement = false;

    if (focus) {
      pmouse = new PVector(pmouseX - position.x, pmouseY - position.y-22);
      mouse = new PVector(mouseX - position.x, mouseY - position.y-22);
    }

    if (appli != null) {                       // Mettre à jour le programme de l'application
      appli.update(mouse, pmouse, taille, focus);
      affichage.beginDraw();
      appli.draw(affichage, taille);
      affichage.endDraw();
    }

    //if (mouseX <= position.x + taille.x && mouseX >= position.x + taille.x - 28 && mouseY >= position.y && mouseY <= position.y + 22 && click && focus)
    if (mouseInRect(position.x + taille.x - 28*scaleMin, position.y, 28*scaleMin, 22*scaleMin)  && click && focus)
      detruire(id);
    if (!(position.x + taille.x>0 && position.y+taille.y>0 && position.x < width && position.y < height))
      detruire(id);
  }

  // ====================================
  // regarder si la souris est dans la fenêtre
  // ====================================
  boolean sourisDansFenetre() {
    return mouseInRect(position.x, position.y, taille.x, taille.y + 22);
  }

  // ====================================
  // dessiner la fenêtre et son contenu
  // ====================================
  void draw() {

    fill(80, 80, 180);
    stroke(0, 0, 255);
    rect(position.x, position.y, taille.x, 22 * scaleY);

    fill(255);
    textSize(20 * scaleY);
    text(appli.getname(), position.x+18*scaleMin, position.y+18*scaleY);

    // if (mouseX <= position.x + taille.x && mouseX >= position.x + taille.x - 28 * scaleMin && mouseY >= position.y && mouseY <= position.y + 22 * scaleMin)
    if (mouseInRect(position.x + taille.x - 28* scaleMin, position.y, 28 * scaleMin, 22 * scaleMin))
      fill(120, 120, 200);
    rect(position.x + taille.x - 28*scaleMin, position.y, 28*scaleMin, 22*scaleMin);

    fill(255, 0, 0);
    textSize(26 * scaleMin);
    text("X", position.x + taille.x - 20 * scaleMin, position.y + 20*scaleMin);

    fill(0, 0, 200);
    noStroke();
    rect(position.x-1, position.y+22*scaleY, taille.x+2, taille.y+1);
    image(affichage, position.x, position.y+22*scaleY);
  }
}
