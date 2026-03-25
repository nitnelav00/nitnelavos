/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 *
 * Le terminal peut être utilisé pour contrôler le reste des fenêtres.
 */
import java.util.Arrays;

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
  HashMap<String, Commande> commandes;

  PVector setup(int id) {
    this.id = id;
    texte = "Terminal Par Nitnelav00 (Couard Añó Presencía Valentin)\nTappez 'help' pour obtenir de l'aide et 'clear' pour effacer l'écran\n";
    font = createFont("Comfortaa Bold", 14);
    position = fichiers.racine; // Le dossier courant est la racine quand il viens d'être crée
    positionTexte = fichiers.getChemin(position);

    commandes = new HashMap<String, Commande>();

    // ajout de toutes les commandes
    commandes.put("help", new CommandeHelp());
    commandes.put("echo", new CommandeEcho());
    commandes.put("clear", new CommandeClear());
    commandes.put("exit", new CommandeExit());
    commandes.put("shutdown", new CommandeShutdown());
    commandes.put("kill", new CommandeKill());
    commandes.put("top", new CommandeTop());
    commandes.put("mkdir", new CommandeMkdir());
    commandes.put("ls", new CommandeLs());
    commandes.put("cd", new CommandeCd());
    commandes.put("cat", new CommandeCat());
    commandes.put("tree", new CommandeTree());
    commandes.put("run", new CommandeRun());
    commandes.put("rm", new CommandeRm());

    return new PVector(600, 600); // le terminal à une talle de 600x600 px
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
    String[] parts = entree.trim().split("\\s+");
    if (parts.length == 0 || parts[0].equals(""))
      return;
    texte += positionTexte+"> " + entree;
    String nomCommande = parts[0];
    String[] args = Arrays.copyOfRange(parts, 1, parts.length);

    Commande cmd = commandes.get(nomCommande);
    if (cmd == null)
      texte += "La commande " + nomCommande + " n'existe pas\n";
    else
      cmd.executer(args, this);
      
    while (texte.lines().count() > 30) // Le termial n'a la place que pour 30 lignes
      texte = texte.substring(texte.indexOf('\n')+1);
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
