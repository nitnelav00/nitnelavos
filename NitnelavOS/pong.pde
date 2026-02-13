
class Pong implements GUIApp {
  int id;
  int nb_joueurs;
  String getname(){
    return "Pong";
  }
  IntList setup(int id, StringList arguments) {
    nb_joueurs = 1;
    if (arguments != null && arguments.size() > 1) {
      if (arguments.get(1).equals("2"))
        nb_joueurs = 2;
    }
    
    int width = 800;
    int height = 600;
    this.id = id;
    println(nb_joueurs);
    return new IntList(width, height);
  }
  
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus){}
  
  void draw(PGraphics pg, float width, float height){}
}
