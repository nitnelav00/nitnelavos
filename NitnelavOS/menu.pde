/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */
 
import java.lang.Thread;
String []apps = {"Terminal", "AppTest", "Fractal", "Cours_13"}; // Liste des applications disponibles

/**
 * Si le programme avec le nom demandé existe, il le crée dans une fenêtre et l'ajoute dans la liste des fenêtres.
 * la position de la fenêtre est optionnelle
 */
void creerApp(String nom, PVector pos, StringList arguments) {
  switch (nom) {
  case "AppTest":
    fenetres.add(0, new Window(pos, new AppTest(), arguments));
    break;
  case "Terminal":
    fenetres.add(0, new Window(pos, new Terminal(), arguments));
    break;
  case "Fractal":
    fenetres.add(0, new Window(pos, new Fractal(), arguments));
    break;
  case "Cours_13":
    fenetres.add(0, new Window(pos, new Cours_13(), arguments));
    break;
  default:
    break;
  }
  redraw();
}

/**
 * La bare du menu est sensé être en bas et utilisée pour lancer les programmes (ne fonctionne pas encore).
 */
void menu() {
  //panic("non implémenté");
  push();

  fill(80, 190, 112);
  rect(0, height - 30, width, height);
  
  for (int i=0; i < apps.length; i++) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(4);
    rect(2 + i*88, height - 30, 85, 28);
  
    fill(0);
    textSize(20);
    text(apps[i], 6 + i*88, height - 10);
    
    if (click && mouseX < 2 + (i+1)*88 && mouseX > 2 + i*88 && mouseY > height - 30) {
      creerApp(apps[i],null,null);
      redraw();
    }
  }
  pop();
}
