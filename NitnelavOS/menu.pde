
void creerApp(String nom, PVector pos) {
  switch (nom) {
  case "AppTest":
    fenetres.add(0, new Window(pos, new AppTest()));
    return;
  case "Terminal":
    fenetres.add(0, new Window(pos, new Terminal()));
    return;
  default:
    return;
  }
}

void menu() {
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
