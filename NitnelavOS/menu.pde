/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */
 
import java.lang.Thread;
String []apps = {"Terminal", "AppTest", "RayTracing"}; // Liste des applications disponibles

/**
 * Si le programme avec le nom demandé existe, il le crée dans une fenêtre et l'ajoute dans la liste des fenêtres.
 * la position de la fenêtre est optionnelle
 */
void creerApp(String nom, PVector pos) {
  switch (nom) {
  case "AppTest":
    fenetres.add(0, new Window(pos, new AppTest()));
    return;
  case "Terminal":
    fenetres.add(0, new Window(pos, new Terminal()));
    return;
  case "RayTracing":
    fenetres.add(0, new Window(pos, new RayTracing()));
    return;
  default:
    return;
  }
}

/**
 * La bare du menu est sensé être en bas et utilisée pour lancer les programmes (ne fonctionne pas encore).
 */
void menu() {
  panic("non implémenté");
  push();

  fill(60, 200, 50);
  rect(0, height - 30, width, height);

  noFill();
  stroke(255, 0, 0);
  strokeWeight(4);
  rect(2, height - 30, 80, 28);

  fill(0);
  textSize(20);
  text("AppTest", 6, height - 10);

  pop();
}
