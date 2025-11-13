
String []apps = {"Terminal", "AppTest"};

boolean estUneApp(String nom) {
  for (int i =0; i<apps.length; i++)
    if (apps[i].equals(nom))
      return true;
  return false;
}

// ====================================
// La console de l'OS
// ====================================
class Terminal implements GUIApp {

  int id;                 // l'ID du proecssus
  String texte = "";      // Le texte de la console
  String entree = "";     // L'entrée utilisateur
  String affichage;       // Le texte à afficher sur l'écran
  PFont font;             // La police d'écriture du terminal

  PVector setup(int id) {
    this.id = id;
    texte = "Terminal Par Nitnelav00 (Couard Añó Presencía Valentin)\nTappez 'help' pour obtenir de l'aide et 'clear' pour effacer l'écran\n";
    font = createFont("Comfortaa Bold", 14);

    return new PVector(600, 600);
  }
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) {
    if (focus && int(lettreAppuyee) != 65535) {
      if (lettreAppuyee != '\b')
        entree += lettreAppuyee;
      else {
        String tmp="";
        for (int i=0; i<entree.length()-1; i++)
          tmp += entree.charAt(i);
        entree = tmp;
      }
    }
    if (focus && touchesAppuyes[10]) {
      texte += "> " + entree;
      computeCommand();
      entree = "";
    }
    if (focus && millis()/500%2==0)
      affichage = texte + "> " + entree + "_";
    else
      affichage = texte + "> " + entree;
  };

  void computeCommand() {
    StringList commands = new StringList();
    commands.append("");
    for (int i =0; i<entree.length(); ++i) {
      char c = entree.charAt(i);
      if (c == '\n')
        break;
      if (c!=32 && c!='\n')
        commands.set(commands.size()-1, commands.get(commands.size()-1) + c);
      else
        commands.append("");
    }
    println(commands);
    switch (commands.get(0)) {
    case "help":
    case "h":
      texte += "commandes disponibles :\nhelp, echo, clear/cls, exit/quit, top, close, kill";
      for (String a : apps)
        texte += ", " + a;
      texte += "\n";
      break;
    case "echo":
      for (int i=1; i<commands.size(); i++)
        texte += commands.get(i) + " ";
      texte+='\n';
      break;
    case "clear":
    case "cls":
      texte="";
      break;
    case "exit":
    case "quit":
      exit();
      break;
    case "close":
      detruire(id);
      break;
    case "kill":
      if (commands.size() < 2) {
        texte += "La commande kill doit avoir l'ID de la fenetre à fermer en argument\n";
      } else {
        try {
          int id = Integer.parseInt(commands.get(1));
          detruire(id);
        }
        catch (NumberFormatException e) {
          texte += "Erreur : " + commands.get(1) + "n'est pas un entier\n";
        }
      }
      break;
    case "top":
      for (Window w : fenetres) {
        texte += "Id : "+ str(w.id) + " | nom :\""+w.appli.getname()+"\"\n";
      }
      break;
    default:
      if (estUneApp(commands.get(0)) || commands.get(0).equals("")) {
        if (commands.size() !=3)
          creerApp(commands.get(0), null);
        else creerApp(commands.get(0), new PVector(int(commands.get(1)), int(commands.get(2))));
      } else texte+="La commande \"" + commands.get(0) + "\" n'existe pas\n";
    }
  }

  String getname() {
    return "Terminal " + str(id);
  }

  void draw(PGraphics pg, PVector taille) {
    pg.background(0);

    pg.textFont(font);
    pg.fill(255);
    pg.text(affichage, 5, 14);
  }
}
