/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */
 
// Fonction pour savoir si l'application existe
boolean estUneApp(String nom) {
  for (int i =0; i<apps.length; i++)
    if (apps[i].equals(nom))
      return true;
  return false;
}

/**
 * Le Terminal de l'OS fonctionne un peu comme celui dans Linux.
 * On peut entrer les commandes avec le clavier si la souris la survole
 */
class Terminal implements GUIApp {

  int id;                 // l'ID du proecssus
  String texte = "";      // Le texte de la console
  String entree = "";     // L'entrée utilisateur
  String affichage;       // Le texte à afficher sur l'écran
  PFont font;             // La police d'écriture du terminal
  Node position;          // Le dossier courant
  String positionTexte;   // le nom du dossier courant

  IntList setup(int id, StringList arguments) {
    this.id = id;
    texte = "Terminal Par Nitnelav00 (Couard Añó Presencía Valentin)\nTappez 'help' pour obtenir de l'aide et 'clear' pour effacer l'écran\n";
    font = createFont("Comfortaa Bold", 14);
    position = fichiers.racine; // Le dossier courant est la racine quand il viens d'être crée
    positionTexte = fichiers.getChemin(position);

    return new IntList(600, 600); // le terminal à une talle de 600x600 px
  }
  
  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) {
    if (focus && int(lettreAppuyee) != 65535) { // si une lettre est appuyée (65535 est le nombre pour signifier que la touche n'est pas une lettre)
      if (lettreAppuyee != '\b') // Si la lettre n'est pas un retour en arrière (backspace) l'ajouter au texte
        entree += lettreAppuyee;
      else {
        String tmp="";
        for (int i=0; i<entree.length()-1; i++) // Sinon copier le texte sans le dernier charactère
          tmp += entree.charAt(i);
        entree = tmp;
      }
    }
    if (focus && touchesAppuyes[10]) { // Si la touche appuyée est la touche entrée
      texte += positionTexte+"> " + entree;
      computeCommand(); // éxecuter le résultat de la commande entrée par l'utilisateur
      entree = "";
    }
    
    // Faire clignoter le curseur si l'utilisateur peut entrer du texte
    if (focus && millis()/500%2==0)
      affichage = texte + positionTexte + "> " + entree + "_";
    else
      affichage = texte + positionTexte + "> " + entree;
  };

  void computeCommand() {
    StringList commands = new StringList();
    commands.append("");
    for (int i =0; i<entree.length(); ++i) { // découper la commande entrée en plusieurs parties
      char c = entree.charAt(i);
      if (c == '\n') // finir au saut de ligne
        break;
      if (c!=32) // Si le character n'est pas un saut de ligne, l'ajouter à la fin de la liste 
        commands.set(commands.size()-1, commands.get(commands.size()-1) + c);
      else
        commands.append("");
    }
    
    switch (commands.get(0)) {
    case "help": // Si la commande est help ou h lister les commandes disponibles
    case "h":
      texte += "commandes disponibles :\nhelp, echo, clear/cls, exit/quit, top, shutdown, kill, mkdir,\nls, cd, tree, cat";
      for (String a : apps)
        texte += ", " + a;
      texte += "\n";
      break;
    case "echo":
      for (int i=1; i<commands.size(); i++) // remettre les arguments dans la même chaine de charactères
        texte += commands.get(i) + " ";
      texte+='\n';
      break;
    case "clear":
    case "cls":
      texte="";
      break;
    case "exit":
    case "quit":
      detruire(id); // fermer le Terminal dans lequel la commande a été entrée
      break;
    case "shutdown":
      exit();
      break;
    case "kill":
      if (commands.size() < 2) {
        texte += "La commande kill doit avoir l'ID de la fenetre à fermer en argument\n";
      } else {
        try {
          int id = Integer.parseInt(commands.get(1)); // mets le premier argument en entier (si possible)
          detruire(id);                               // puis détruit l'application
        }
        catch (NumberFormatException e) {
          texte += "Erreur : " + commands.get(1) + "n'est pas un entier\n";
        }
      }
      break;
    case "top": // affiche la liste des fenêtres actives et leur ID
      for (Window w : fenetres) {
        texte += "Id : "+ str(w.id) + " | nom :\""+w.appli.getname()+"\"\n";
      }
      break;
    case "mkdir": // crée en dossier
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
    case "ls": // Liste les dossiers et fichiers
      texte += position.listerEnfants() + "\n";
      break;
    case "cd":
      if (commands.size() < 2) {
        texte += "La commande cd doit avoir le nom du fichier en argument\n";
        break;
      }
      if (commands.get(1).equals("..")) { // remonter au parent si .. est choisie
        if (position.parent != null) {  // <- Protection
          position = position.parent;
          positionTexte = fichiers.getChemin(position);
        } else {
          texte += "Vous êtes déjà à la racine\n";
        }
        break;
      }
      if (position.enfants == null) break;
      for (Node enfant : position.enfants){
        if (enfant.nom.equals(commands.get(1)) && enfant.estDossier) { // regarder quel enfant correspond au nom demandé puis s'y déplacer s'il est un dossier
            position = enfant;
            positionTexte = fichiers.getChemin(position);
            return;
          }
        }
      texte += "Le dossier " + commands.get(1) + " n'éxiste pas\n";
      break;
    case "tree":
      texte += fichiers.tree(position);
      break;
    case "cat":
      if (commands.size() < 2) {
        texte += "La commande cd doit avoir le nom du fichier en argument\n";
        break;
      }
      String nomFichier = commands.get(1);
      boolean fichierTrouve = false;
      if (position.enfants != null) {
        for (Node enfant : position.enfants) {
          if (enfant.nom.equals(nomFichier)) {
            if (enfant.estDossier) {
              texte += nomFichier + " est un dossier (utilisez cd)\n";
            } else {
              texte += "Contenu de " + nomFichier + ":\n";
              texte += enfant.contenu + "\n";
            }
            fichierTrouve = true;
            break;
          }
        }
      }
      if (!fichierTrouve) {
        texte += "Le fichier \"" + nomFichier + "\" n'existe pas\\n";
      }
      break;
    default:
      if (estUneApp(commands.get(0)) || commands.get(0).equals("")) { // crée une application si elle existe
        float x=random(1.);
        float y=random(1.);
        creerApp(commands.get(0), new PVector(x, y), commands); // crée l'application avec la position si donnée en paramètre
      } else texte+="La commande \"" + commands.get(0) + "\" n'existe pas\n";
    }
  }

  String getname() {
    return "Terminal " + str(id);
  }

  void draw(PGraphics pg, float width, float height) {
    pg.background(0);

    pg.textFont(font);
    pg.fill(255);
    pg.text(affichage, 5, 14);
  }
}
