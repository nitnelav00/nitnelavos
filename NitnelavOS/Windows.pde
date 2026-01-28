/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */

static int compteur = 0; // le compteur sert à générer les ID

/**
 * La classe Window sert à créer les fenêtres et les gérer
 * à la création elle prends la potition de la fenêtre et l'application qui doit être dedans en arguments
 */
class Window {
  PVector position; // Position de la fenètre
  PVector taille; // Taille de la fenètre
  GUIApp appli; // L'application contenue dans la fenêtre
  boolean deplacement = true; // Savoir si la fenêtre est en train de se faire déplacer
  PGraphics affichage; // Rendu graphique de la fenetre

  PVector mouse;
  PVector pmouse;
  int id;

  /**
   * Le constructeur de la fonction prends la position de la fenêtre (optionnel) et l'application qui doit être dedans en arguments
   * @position    : PVector (optionnel)
   * @application : GUIApp
   */
  Window(PVector position, GUIApp application, StringList arguments) {

    this.appli = application;

    mouse = new PVector(0., 0.); // position actuelle de la souris quand elle est dans la fenêtre
    pmouse = new PVector(0., 0.); // position précédente de la souris quand elle est dans la fenêtre

    id = compteur++; // obtenir un ID puis incrémenter le compteur
    this.taille = appli.setup(id, arguments); // créer l'application avec l'id en argument et obtenir la taille de la fenêtre de l'appli

    affichage = createGraphics(int(taille.x), int(taille.y), P2D); // Créer l'interface graphique avec la même taille que la fenètre
    affichage.beginDraw();
    affichage.background(0); // ou ce que tu veux
    affichage.endDraw();

    // Si une position est entrée, déplacer la fenêtre à la position, sinon mettre la fenêtre au centre de l'écran
    if (position != null)
      this.position = new PVector(lerp(0, width-taille.x, position.x), lerp(0, height-taille.y - 22, position.y));
    else
      this.position = new PVector(width/2. - taille.x/2., height/2. - taille.y/2.);
    draw();
  }

  /**
   * Fonction de mise à jour de la fenêtre
   */
  void update(boolean focus) { //<>//
    
    if (mouseInRect(position.x, position.y, taille.x, 22 * scaleY) && click && focus) // Si l'utilisateur clique sur le bandeau en haut de la fenêtre, elle est en déplacement
      deplacement = true;
    
    
    // déplacer la fenêtre si besoin
    if (pmouseX >= position.x && pmouseX <= position.x + taille.x && pmouseY >= position.y && pmouseY <= position.y + 22 * scaleY && mousePressed && deplacement) {
      position.x += mouseX - pmouseX;
      position.y += mouseY - pmouseY;
      redraw(); // ne pas oublier de redessiner le fon d'écran pour le pas laisser des traces
      draw();
    } else deplacement = false; // si la fenêtre est lachée, elle ne se déplace plus

    if (focus) { // si l'utilisateur survole la fenêtre avec sa souris, changer la position de la souris par relatif avec la fenêtre
      pmouse = new PVector(pmouseX - position.x, pmouseY - position.y-22);
      mouse = new PVector(mouseX - position.x, mouseY - position.y-22);
    }


    if (appli != null) {
      appli.update(mouse, pmouse, taille, focus); // Mettre à jour le programme de l'application //<>//
      if (affichage == null){
        affichage = createGraphics(int(taille.x), int(taille.y), P2D);
        println("erreur affichage");
      }
      affichage.beginDraw();
        appli.draw(affichage, taille.x, taille.y); // dessinner le contenu dans l'image qui sera affichée plus tard
      affichage.endDraw();
    }
    
    // Détruire la fenêtre si la croix est cliquée
    if (mouseInRect(position.x + taille.x - 28*scaleMin, position.y, 28*scaleMin, 22*scaleMin)  && click && focus)
      detruire(id);
    // Détruire la fenêtre si elle sort de l'écran // finalement non
    // if (!(position.x + taille.x>0 && position.y+taille.y>0 && position.x < width && position.y < height))
    //   detruire(id);
     
  }

  /**
   * Regarder si la souris est dans la fenêtre
   */
  boolean sourisDansFenetre() {
    return mouseInRect(position.x, position.y, taille.x, taille.y + 22);
  }

  /**
   * dessiner la fenêtre et son contenu
   */
  void draw() {

    // Dessiner le contour de la fenêtre
    fill(80, 80, 180);
    stroke(0, 0, 255);
    rect(position.x, position.y, taille.x, 22 * scaleY);

    // Afficher le nom de l'application sur la fenêtre
    fill(255);
    textSize(20 * scaleY);
    text(appli.getname(), position.x+18*scaleMin, position.y+18*scaleY);

    // Colorier le boutton de croix si la souris le survole
    if (mouseInRect(position.x + taille.x - 28* scaleMin, position.y, 28 * scaleMin, 22 * scaleMin))
      fill(120, 120, 200);
    rect(position.x + taille.x - 28*scaleMin, position.y, 28*scaleMin, 22*scaleMin);

    // Dessiner la croix
    fill(255, 0, 0);
    textSize(26 * scaleMin);
    text("X", position.x + taille.x - 20 * scaleMin, position.y + 20*scaleMin);

    // dessinner l'application
    fill(0, 0, 200);
    noStroke();
    rect(position.x-1, position.y+22*scaleY, taille.x+2, taille.y+1);
    image(affichage, position.x, position.y+22*scaleY);
  }
}
