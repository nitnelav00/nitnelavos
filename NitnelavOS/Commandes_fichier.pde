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
    
    terminal.texte += texteUtilisateur.trim().replace("\\n", "\n") + '\n';
    
    if (dansFichier) {
      // Ton code existant pour écrire dans le fichier
      Node destination;
      if (args[0].charAt(0) == '/')
        destination = fichiers.racine;
      else destination = terminal.position;

      String chemin[] = args[fichierDestinationIndex].split("/");
      destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);

      if (destination == null) {
        terminal.texte += "Erreur : chemin \"" + args[fichierDestinationIndex] + "\" inaccessible.\n";
        return;
      }
      
      if (destination.enfants.get(chemin[chemin.length -1]) == null) {
        destination = fichiers.creerNode(chemin[chemin.length -1], false, destination);
        if (destination == null) {
          terminal.texte += "Erreur : impossible de créer le fichier \"" + chemin[chemin.length -1] + "\".\n";
          return;
        }
      }

      destination.contenu = texteUtilisateur.trim();
      terminal.texte += "Ecriture dans \"" + args[fichierDestinationIndex] + "\" effectuée.\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Afficher du texte ou l'écrire dans un fichier.\n" +
        "\n" +
        "Utilisation :\n" +
        "  echo <texte>              Affiche le texte\n" +
        "  echo <texte> > <fichier>  Écrit le texte dans le fichier\n" +
        "\n" +
        "Exemples :\n" +
        "  echo Bonjour le monde\n" +
        "  echo Salut > ./coucou/texte.txt\n";
    }
    return "Afficher du texte (avec redirection '> fichier').";
  }
}

/*
 * Commande pour créer un ou des dossier
 */
class CommandeMkdir implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte +=
        "Erreur : aucun dossier spécifié.\n" +
        "Usage : mkdir <nom_dossier>\n";
      return;
    }

    Node destination;
    if (args[0].charAt(0) == '/')
      destination = fichiers.racine;
    else destination = terminal.position;

    String chemin[] = args[0].split("/");

    destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);
    if (destination == null) return;

    String nom = chemin[chemin.length - 1];
    if (fichiers.creerNode(nom, true, destination) != null)
      terminal.texte += "Dossier \"" + nom + "\" créé.\n";
    else
      terminal.texte += "Erreur : impossible de créer le dossier \"" + nom + "\".\n";
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Créer un dossier à l'emplacement indiqué.\n" +
        "\n" +
        "Utilisation :\n" +
        "  mkdir <nom_dossier>\n" +
        "\n" +
        "Exemple :\n" +
        "  mkdir /bonjour/dossier/../coucou\n" +
        "  crée un dossier nommé coucou dans le répertoire NitnelavOS/bonjour\n";
    }
    return "Créer un dossier avec le nom et le chemin donnés en argument.";
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
    if (avecExemples) {
      return
        "Lister les fichiers et dossiers du dossier courant.\n" +
        "\n" +
        "Utilisation :\n" +
        "  ls\n" +
        "\n" +
        "Exemple :\n" +
        "  ls\n";
    }
    return "Lister les fichiers et dossiers du dossier courant.";
  }
}

/*
 * Commande pour se déplacer dans les dossiers
 */
class CommandeCd implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte +=
        "Erreur : aucun dossier spécifié.\n" +
        "Usage : cd <chemin>\n";
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
    if (avecExemples) {
      return
        "Changer de dossier.\n" +
        "\n" +
        "Utilisation :\n" +
        "  cd <chemin>\n" +
        "\n" +
        "Exemples :\n" +
        "  cd dossier\n" +
        "  cd ../autre_dossier\n" +
        "  cd /racine/dossier\n" +
        "  cd .\n" +
        "  cd ..\n";
    }
    return "Changer de dossier à l'aide d'un chemin relatif ou absolu.";
  }
}

/*
 * Commande pour supprimmer un dossier ou fichier
 */
class CommandeRm implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += 
        "Erreur : aucun fichier/dossier spécifié.\n" +
        "Usage : rm <fichier_ou_dossier>\n";
      return;
    }
    
    Node destination;
    if (args[0].charAt(0) == '/')
      destination = fichiers.racine;
    else destination = terminal.position;

    String chemin[] = args[0].split("/");
    destination = obtenirNode(destination, chemin, chemin.length - 1, terminal);
    if (destination == null) {
      terminal.texte += 
        "Erreur : \"" + args[0] + "\" introuvable.\n" +
        "Vérifiez le chemin avec \"ls\" ou \"tree\".\n";
      return;
    }
    
    destination.enfants.remove(chemin[chemin.length-1]);
    terminal.texte += "Fichier/dossier \"" + args[0] + "\" supprimé.\n";
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Supprimer un fichier ou dossier.\n" +
        "\n" +
        "Utilisation :\n" +
        "  rm <fichier_ou_dossier>\n" +
        "\n" +
        "Exemples :\n" +
        "  rm rapport.txt\n" +
        "  rm ./coucou/texte.txt\n";
    }
    return "Supprimer un fichier ou dossier.";
  }
}

/*
 * Afficher tout les dossiers et fichier
 */
class CommandeTree implements Commande {

  void executer(String[] args, Terminal terminal) {
    if (args.length != 0) {
      terminal.texte +=
        "Erreur : la commande tree ne prend pas d'arguments.\n" +
        "Usage : tree\n";
      return;
    }

    String arbre = fichiers.tree(terminal.position);
    if (arbre.isEmpty()) {
      terminal.texte += "Dossier courant vide.\n";
    } else {
      terminal.texte += "Arborescence depuis \"" + terminal.position.nom + "\" :\n\n";
      terminal.texte += arbre + "\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Afficher l'arborescence des dossiers/fichiers depuis le dossier courant.\n" +
        "\n" +
        "Utilisation :\n" +
        "  tree\n" +
        "\n" +
        "Exemple :\n" +
        "  tree\n";
    }
    return "Afficher l'arborescence des fichiers/dossiers.";
  }
}

/*
 * Lire le contenu d'un fichier
 */
class CommandeCat implements Commande {

  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte +=
        "Erreur : aucun fichier spécifié.\n" +
        "Usage : cat <fichier>\n";
      return;
    }

    String nomFichier = args[0];
    Node enf = terminal.position.enfants.get(nomFichier);

    if (enf != null) {
      if (enf.estDossier) {
        terminal.texte +=
          "Erreur : \"" + nomFichier + "\" est un dossier, pas un fichier.\n" +
          "Utilisez \"ls\" pour lister son contenu.\n";
      } else {
        terminal.texte += enf.contenu + "\n";
      }
    } else {
      terminal.texte +=
        "Erreur : fichier \"" + nomFichier + "\" introuvable.\n" +
        "Vérifiez le nom ou utilisez \"ls\" pour lister les fichiers.\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Afficher le contenu d'un fichier.\n" +
        "\n" +
        "Utilisation :\n" +
        "  cat <fichier>\n" +
        "\n" +
        "Exemple :\n" +
        "  cat rapport.txt\n";
    }
    return "Afficher le contenu d'un fichier.";
  }
}
