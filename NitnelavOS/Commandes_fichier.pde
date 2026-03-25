/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2026.
 *
 * Les commandes utilisé par l'utilisateur pour naviguer et modifier les fichiers et dossiers de l'OS
 */

Node obtenirNode(Node dossierSource, String[] chemin, int longueurChemin, Terminal terminal) {
  Node dossier = dossierSource;
  if (longueurChemin > chemin.length) panic("la longueur du chemin n'est pas correcte");
  for (int i = 0; i < longueurChemin; i++) { // parcourir toute la longueur du chemin demandé
    String nom = chemin[i];
    if (nom.equals("..")) {
      if (dossier.parent == null) {
        terminal.texte += dossier.nom + " est déjà la racine\n";
        return null;
      }
      dossier = dossier.parent;
    } else if (nom.equals("."))
      continue;
    else {
      dossier = dossier.enfants.get(nom);
      if (dossier == null || !dossier.estDossier) { // le dossier ne doit pas être un fichier
        terminal.texte += "Le dossier " + nom + " n'existe pas\n";
        return null;
      }
    }
  }
  return dossier;
}

/*
 * Commande echo
 */
class CommandeEcho implements Commande {
  void executer(String[] args, Terminal terminal) {

    String texteUtilisateur = "";
    boolean dansFichier = false;
    int fichierDestinationIndex = 0;

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals(">")) {
        dansFichier = true;
        fichierDestinationIndex = i+1;
        break;
      }
      texteUtilisateur += args[i] + " ";
    }
    terminal.texte += texteUtilisateur + "\n";
    if (dansFichier) {
      Node destination;
      if (args[0].charAt(0) == '/')
        destination = fichiers.racine;
      else destination = terminal.position;

      String chemin[] = args[fichierDestinationIndex].split("/");
      destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);

      if (destination == null) return;
      if (destination.enfants.get(chemin[chemin.length -1]) == null) {
        destination = fichiers.creerNode(chemin[chemin.length -1], false, destination);
        if (destination == null) {
          terminal.texte += "Erreur à la création du fichier\n";
          return;
        }
      }

      destination.contenu = texteUtilisateur;
    }
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples) return "Le texte donné en argument sera affiché dans le Terminal\nIl est possible d'utiliser '>' pour envoyer\n le résultat dans un fichier\nExemple : echo bonjour vous > ./coucou/texte.txt";
    return "Affiche le texte donné en argument. Utilisez '>' pour écrire dans un fichier";
  }
}

/*
 * Commande pour créer un ou des dossier
 */
class CommandeMkdir implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "La commande mkdir doit avoir le nom du fichier en argument\n";
      return;
    }
    Node destination;
    if (args[0].charAt(0) == '/')
      destination = fichiers.racine;
    else destination = terminal.position;

    String chemin[] = args[0].split("/");

    destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);
    if (destination == null) return;

    String nom = chemin[chemin.length-1]; // le dernier élément est le nom du fichier a créer
    if (fichiers.creerNode(nom, true, destination) != null)
      terminal.texte += "le fichier " + nom + " a été crée\n";
    else
      terminal.texte += "le fichier " + nom + " n'a pas pu être crée\n";
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples) return "Crée un dossier avec le nom et le chemin donné en argument\nExemple : mkdir /bonjour/dossier/../coucou\ncréera un dossier nommé coucou dans le répertoire NitnelavOS/bonjour";
    return "Crée un dossier avec le nom donné en argument";
  }
}

/*
 * Commande pour lister les dossiers et fichiers
 */
class CommandeLs implements Commande {
  void executer(String[] args, Terminal terminal) {
    terminal.texte += terminal.position.listerEnfants() + "\n";
  }
  String getDescription(boolean avecExemples) {
    return "Lister les dossiers et fichiers du dossier courant";
  }
}

/*
 * Commande pour se déplacer dans les dossiers
 */
class CommandeCd implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "La commande cd doit avoir le nom du fichier en argument\n";
      return;
    }
    Node destination;
    if (args[0].charAt(0) == '/')
      destination = fichiers.racine;
    else destination = terminal.position;

    String chemin[] = args[0].split("/");

    destination = obtenirNode(destination, chemin, chemin.length, terminal);
    if (destination == null) return;

    terminal.position = destination;
    terminal.positionTexte = fichiers.getChemin(destination);
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples) return "Utiliser cette fonction pour se déplacer dans les dossiers\nIl est possible d'utiliser '..' pour revenir en arrière\n'.' pour rester au même niveau\net '/' pour être à la racine";
    return "Utiliser cette fonction pour se déplacer dans les dossiers";
  }
}

/*
 * Commande pour supprimmer un dossier ou fichier
 */
class CommandeRm implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "La commande rm doit avoir le nom du fichier en argument\n";
      return;
    }
    Node destination;
    if (args[0].charAt(0) == '/')
      destination = fichiers.racine;
    else destination = terminal.position;

    String chemin[] = args[0].split("/");
    destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);
    if (destination == null) return;
    destination.enfants.remove(chemin[chemin.length-1]); // le dernier élément est le nom du fichier a retirer
  }
  String getDescription(boolean avecExemples) {
    return "Utiliser cette fonction pour supprimmer un dossier ou fichier";
  }
}

/*
 * Afficher tout les dossiers et fichier
 */
class CommandeTree implements Commande {
  void executer(String[] args, Terminal terminal) {
    terminal.texte += fichiers.tree(terminal.position);
  }
  String getDescription(boolean avecExemples) {
    return "Afficher tout les dossiers et fichier à partir du dossier courant";
  }
}

/*
 * Lire le contenu d'un fichier
 */
class CommandeCat implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "La commande cd doit avoir le nom du fichier en argument\n";
      return;
    }
    String nomFichier = args[0];
    Node enf = terminal.position.enfants.get(nomFichier);

    if (enf != null) {
      if (enf.estDossier) {
        terminal.texte += "C'est un dossier\n";
      } else {
        terminal.texte += enf.contenu + "\n";
      }
    } else {
      terminal.texte += "Fichier introuvable\n";
    }
  }
  String getDescription(boolean avecExemples) {
    return "Lire le contenu d'un fichier";
  }
}
