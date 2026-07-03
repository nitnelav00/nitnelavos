/**
 * Programme crée par Nitnelav00 en 2025.
 */

String []apps = {"Terminal", "AppTest", "Fractal", "Cours_13", "Flappy"}; // Liste des applications disponibles

/**
 * Si le programme avec le nom demandé existe, il le crée dans une fenêtre et l'ajoute dans la liste des fenêtres.
 * la position de la fenêtre est optionnelle
 */
void creerApp(String nom, PVector pos) {
  switch (nom) {
  case "AppTest":
    fenetres.add(0, new Window(pos, new AppTest()));
    break;
  case "Terminal":
    fenetres.add(0, new Window(pos, new Terminal()));
    break;
  case "Fractal":
    fenetres.add(0, new Window(pos, new Fractal()));
    break;
  case "Cours_13":
    fenetres.add(0, new Window(pos, new Cours_13()));
    break;
  case "Flappy":
    fenetres.add(0, new Window(pos, new Flappy()));
  default:
    break;
  }
  redraw();
}

/**
 * La bare du menu est censé être en bas et utilisée pour lancer les programmes.
 */
void menu() {
  //panic("non implémenté");
  push();

  final int TAILLE_DE_LA_BARRE = 30;

  fill(#50BE70);
  rect(0, height - TAILLE_DE_LA_BARRE, width, height);

  for (int i=0; i < apps.length; i++) {
    noFill();
    stroke(255, 0, 0);

    if (mouseX < 2 + (i+1)*88 && mouseX > 2 + i*88 && mouseY > height - TAILLE_DE_LA_BARRE) {
      fill(#44A05E);
      if (click) {
        float x=random(1.);
        float y=random(1.);
        creerApp(apps[i], new PVector(x, y));
        redraw();
      }
    }

    strokeWeight(4);
    rect(2 + i*88, height - TAILLE_DE_LA_BARRE, 85, 28);

    fill(0);
    textSize(20);
    text(apps[i], 6 + i*88, height - 10);
  }

  if (mouseX > width-80 && mouseY > height-TAILLE_DE_LA_BARRE) {
    fill(#CEA53C);
    if (click) exit();
  } else
    fill(#F5C448);
  rect(width-80, height-TAILLE_DE_LA_BARRE, 80, TAILLE_DE_LA_BARRE);
  fill(0);
  text("Quitter", width-75, height-10);

  pop();
}
