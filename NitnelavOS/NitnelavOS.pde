/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 *
 * Comme c'est le fichier principal il y a des fonctions de base comme setup(), draw() etc.
 * La plupart des variables globales utilisés dans l'entiereté du programme sont définies ici.
 */

SystemFichiers fichiers; // Arbre de fichiers de l'OS

ArrayList<Window> fenetres; // Liste des fenêtres actives
boolean click = false; // Lire le front montant d'un click de souris
IntList aDetruire; // Liste des fenêtres à détruire
PGraphics fondEcran; // image du fond d'écran
boolean fondSale = true;

/* mise à l'échelle de l'écran par rapport à l'affichage */
float scaleX; // en x
float scaleY; // en y
float scaleMin; // le minimum des deux

boolean[] touchesAppuyes; // liste des touches appuyées
boolean touche; // savoir si une touche viens d'être pressée
char lettreAppuyee = 65535; // la lettre qui viens juste d'être pressée (utile pour que l'utilisateur puisse écrire du texte dans le terminal)
boolean lettre; // savoir si une lettre viens d'être pressé

void setup() {
  size(1920, 1080, P2D); // taille pour tester
  //fullScreen(P2D); // pleine écran (mode normal)

  /**
   * mise à l'échelle de l'écran par rapport à l'affichage
   * avec une racine carré parce que la surface d'un carré est de c*c
   */
  scaleX = sqrt(width/1920.); // en x
  scaleY = sqrt(height/1080.); // en y
  scaleMin = min(scaleX, scaleY); // le minimum des ceux

  aDetruire = new IntList(); // liste des fenêtres à détruire

  fenetres = new ArrayList<Window>(); // liste des fenêtres présent sur l'écran

  touchesAppuyes = new boolean[65535]; // liste des touches, true quand la touche est appuyée sinon false

  PImage fondEcranImage; // précalcule l'image du fond d'écran pour les performances
  fondEcranImage = loadImage("img1.jpeg"); // l'image est dans data/img1.png
  fondEcran = createGraphics(width, height, P2D);
  fondEcran.beginDraw();
  fondEcran.image(fondEcranImage, 0, 0, width, height);
  fondEcran.endDraw();
  print("chargé\n");

  fichiers = new SystemFichiers("nitnelavOS"); // initialiser le système de fichiers de l'OS
  fondSale = true;
  redraw();
  menu();
  chargerLeSystemeDeFichier();
}

void draw() {
  if (frameCount <= 1)
    return;
   
  if (fondSale) {
    image(fondEcran, 0, 0); // Redessiner le fond si l'écran est sale
    fondSale = false;
  }
  

  /* Les fenetres à dértuire sont listé selon leur Id et sont détruites au début de la boucle */
  if (aDetruire.size() > 0) {
    fenetres.remove(aDetruire.get(0));
    aDetruire.remove(0);
    redraw();
  }
  
  /**
   * On fait une boucle pour savoir quelle fenêtre obtient le focus
   */
  int focus = -1;
  for (int i = 0; i<fenetres.size(); i++) {
    fenetres.get(i).update(focus == -1 && fenetres.get(i).sourisDansFenetre());
    if (fenetres.get(i).sourisDansFenetre() && focus == -1)
      focus = i;
  }
  
  /**
   * La fenetre qui obtien le focus de l'utilsateur en passant sa souris dessus est placée au premier plan
   */
  if (focus != -1 && focus != 0 && focus < fenetres.size()) {
    Window temp = fenetres.get(focus);
    fenetres.remove(focus);
    fenetres.add(0, temp);
  }

  // les fenêtres se font dessinées sur l'écran
  for (int i = fenetres.size() - 1; i>=0; i--) {
    fenetres.get(i).draw();
  }
  
  // change le titre de la fenêtre pour afficher les fps (utile pour l'optimisation)
  windowTitle("Programme de Valentin, FPS:" + nf(frameRate, 0, 1));
  menu();

  /**
   * Remettre les variables à 0 pour n'avoir que le front montant (le momment où on appuie)
   */
  click = false;
  touchesAppuyes = new boolean[65535];
  lettreAppuyee = 65535;
  touche=false;
}

/**
 * Redessiner le fond d'écran quand besoin (mouvement ou suppression d'une fenêtre)
 * Ne pas le redessiner à chaque fois à cause de pertes de performances
 */
void redraw() {
  if (fondEcran == null) {
    println("erreur du fond d'écran");
    PImage fondEcranImage; // précalcule l'image du fond d'écran pour les performances
    fondEcranImage = loadImage("img1.jpeg"); // l'image est dans data/img1.png
    fondEcran = createGraphics(width, height, P2D);
    fondEcran.beginDraw();
    fondEcran.image(fondEcranImage, 0, 0, width, height);
    fondEcran.endDraw();
  }
  image(fondEcran, 0, 0);
  fondSale = true;
}

/**
 * Mettre la valeur click au momment où la un boutton de la souris est appuyée
 * Cette variable repassera à false à la fin de l'image suivante
 */
void mousePressed(MouseEvent event) {
  if (event.getButton() == 37)
    click = true;
}

/**
 * Quand une touche est appuyée, la variable touche se met à true,
 * La variable lettreAppuyee prends la valeur de la lettre
 * La valeur de la touche correspondante dans touchesAppuyes se met à true
 * Ces variables repasseront à false à la fin de l'image suivante
 */
void keyPressed() {
  lettreAppuyee = key;
  touchesAppuyes[keyCode] = true;
  touche=true;
}

/**
 * Fonction pour détruire la fenêtre avec l'ID correspondant en la stoquant dans une liste
 * @id : int
 */
void detruire(int id) {
  for (int i = 0; i<fenetres.size(); i++) {
    if (fenetres.get(i).id == id)
      aDetruire.append(i);
  }
}

/**
 * Fonction pour savoir si la souris est dans un rectangle à la position x,y et de taille w,h (en pixels)
 */
boolean mouseInRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

/**
 * Cette fonction est appelée à la fermeture du programme
 * à changer
 */
void exit() {
  println(fichiers.tree(fichiers.racine));
  sauvegarderLeSystemeDeFichier();
  super.exit();
}

/**
 * Renvoie l'erreur dans une fenêtre séparée et ferme le programme
 */
void panic(Object err) {
  javax.swing.JOptionPane.showInternalMessageDialog(null, err,
    "Erreur", javax.swing.JOptionPane.ERROR_MESSAGE);
  exit();
}
