
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
  Node position;
  String positionTexte;

  PVector setup(int id) {
    this.id = id;
    texte = "Terminal Par Nitnelav00 (Couard Añó Presencía Valentin)\nTappez 'help' pour obtenir de l'aide et 'clear' pour effacer l'écran\n";
    font = createFont("Comfortaa Bold", 14);
    position = fichiers.racine;
    positionTexte = fichiers.getChemin(position);

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
      texte += positionTexte+"> " + entree;
      computeCommand();
      entree = "";
    }
    if (focus && millis()/500%2==0)
      affichage = texte + positionTexte + "> " + entree + "_";
    else
      affichage = texte + positionTexte + "> " + entree;
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
    switch (commands.get(0)) {
    case "help":
    case "h":
      texte += "commandes disponibles :\nhelp, echo, clear/cls, exit/quit, top, close, kill, proc, pkill, mkdir, ls, cd";
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
    case "pkill":
      if (commands.size() < 2) {
        texte += "La commande pkill doit avoir l'ID du processus à fermer en argument\n";
      } else {
        try {
          int id = Integer.parseInt(commands.get(1));
          pdetruire(id);
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
    case "proc":
      for (Processus w : process) {
        texte += "Id : "+ str(w.getId()) + " | nom :\""+w.getname()+"\"\n";
      }
      break;
    case "mkdir":
      if (commands.size() < 2) {
        texte += "La commande mkdir doit avoir le nom du fichier en argument\n";
        break;
      }
      String nom = commands.get(1);
      if (fichiers.creerNode(nom, true, position) != null)
        texte += "le fichier " + nom + " a été crée\n";
      else
        texte += "le fichier " + nom + " n'a pas pu être crée\n";
      break;
    case "ls":
      texte += position.listerEnfants() + "\n";
      break;
    case "cd":
      if (commands.size() < 2) {
        texte += "La commande cd doit avoir le nom du fichier en argument\n";
        break;
      }
      if (commands.get(1).equals("..")) {
        position = position.parent;
        positionTexte = fichiers.getChemin(position);
        return;
      }
      for (Node enfant : position.enfants){
        if (enfant.nom.equals(commands.get(1))) {
            position = enfant;
            positionTexte = fichiers.getChemin(position);
            return;
          }}
      texte += commands.get(1) + " n'éxiste pas\n";
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
