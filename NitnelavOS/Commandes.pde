/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2026.
 *
 * Les commandes seront crées avec l'interface Commande
 */

interface Commande {
  void executer(String[] args, Terminal terminal); // args = arguments, terminal pour accès aux fonctions
  String getDescription(boolean avecExemples); // pour afficher dans help
}

/*
 * Commande pour afficher l'aide
 */
class CommandeHelp implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Cas : help <commande1> <commande2> ...
    if (args.length != 0) {
      for (String nomCommande : args) {
        Commande cmd = terminal.commandes.get(nomCommande);
        if (cmd == null) {
          terminal.texte +=
            "Erreur : la commande \"" + nomCommande + "\" n'existe pas.\n";
        } else {
          terminal.texte +=
            "Commande : " + nomCommande + "\n" +
            cmd.getDescription(true) + "\n";
        }
      }
      return;
    }

    // Cas : help sans argument -> liste des commandes
    terminal.texte += "Commandes disponibles :\n";
    for (String nomCommande : terminal.commandes.keySet()) {
      Commande cmd = terminal.commandes.get(nomCommande);
      terminal.texte +=
        "  " + nomCommande + " : " + cmd.getDescription(false) + "\n";
    }
    terminal.texte +=
      "\nTapez \"help <commande>\" pour obtenir de l'aide détaillée sur une commande.\n";
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Afficher l'aide sur les commandes du terminal.\n" +
        "\n" +
        "Utilisation :\n" +
        "  help                Affiche la liste des commandes disponibles\n" +
        "  help <commande>     Affiche une aide détaillée pour <commande>\n" +
        "\n" +
        "Exemples :\n" +
        "  help\n" +
        "  help run\n" +
        "  help base64\n";
    }
    return "Afficher la liste des commandes ou l'aide détaillée d'une commande.";
  }
}

/*
 * Commande pour netoyer l'affichage du terminal
 */
class CommandeClear implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Ne rien faire si des arguments sont fournis
    if (args.length != 0) {
      terminal.texte +=
        "Erreur : la commande clear ne prend pas d'arguments.\n" +
        "Usage : clear\n";
      return;
    }

    terminal.texte = "";
    terminal.texte += "Terminal vidé.\n";  // Confirmation subtile
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Vider l'affichage du terminal.\n" +
        "\n" +
        "Utilisation :\n" +
        "  clear\n" +
        "\n" +
        "Exemple :\n" +
        "  clear\n";
    }
    return "Vider l'affichage du terminal.";
  }
}

/*
 * Commande pour quitter le terminal
 */
class CommandeExit implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Ne rien faire si des arguments sont fournis
    if (args.length != 0) {
      terminal.texte +=
        "Erreur : la commande exit ne prend pas d'arguments.\n" +
        "Usage : exit\n";
      return;
    }

    detruire(terminal.id);
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Fermer le terminal.\n" +
        "\n" +
        "Utilisation :\n" +
        "  exit\n" +
        "\n" +
        "Exemple :\n" +
        "  exit\n";
    }
    return "Fermer le terminal.";
  }
}

/*
 * Commande pour quitter l'OS
 */
class CommandeShutdown implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Ne rien faire si des arguments sont fournis
    if (args.length != 0) {
      terminal.texte +=
        "Erreur : la commande shutdown ne prend pas d'arguments.\n" +
        "Usage : shutdown\n";
      return;
    }

    exit();
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Fermer completement le systeme (sauvegarde automatique).\n" +
        "\n" +
        "Utilisation :\n" +
        "  shutdown\n" +
        "\n" +
        "Exemple :\n" +
        "  shutdown\n";
    }
    return "Fermer completement le systeme.";
  }
}

/*
 * Commande pour détruire les applications à distance
 */
class CommandeKill implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Pas d'arguments
    if (args.length == 0) {
      terminal.texte +=
        "Erreur : aucun ID de fenêtre spécifié.\n" +
        "Usage : kill <id_fenetre> [id_fenetre2 ...]\n" +
        "Tapez \"top\" pour voir les ID des fenêtres ouvertes.\n";
      return;
    }

    int nbFenetresFerme = 0;
    for (String idStr : args) {
      try {
        int id = Integer.parseInt(idStr);

        detruire(id);
        terminal.texte += "Fenetre " + id + " fermee. (si elle existe)\n";
        nbFenetresFerme++;
      }
      catch (NumberFormatException e) {
        terminal.texte +=
          "Erreur : \"" + idStr + "\" n'est pas un ID valide (doit être un entier).\n";
      }
    }

    if (nbFenetresFerme > 0) {
      terminal.texte += nbFenetresFerme + " fenêtre(s) fermée(s) avec succès.\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Fermer une ou plusieurs fenêtres par leur ID.\n" +
        "\n" +
        "Utilisation :\n" +
        "  kill <id>                   Ferme la fenêtre avec l'ID donné\n" +
        "  kill <id1> <id2> ...        Ferme plusieurs fenêtres\n" +
        "\n" +
        "Exemples :\n" +
        "  top          (voir les ID disponibles)\n" +
        "  kill 42\n" +
        "  kill 1 3 7\n";
    }
    return "Fermer des fenêtres par leur ID (voir avec 'top').";
  }
}

/*
 * Commande pour afficher les applications présentes à l'écran
 */
class CommandeTop implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Ne rien faire si des arguments sont fournis
    if (args.length != 0) {
      terminal.texte +=
        "Erreur : la commande top ne prend pas d'arguments.\n" +
        "Usage : top\n";
      return;
    }

    // Cas vide : aucune fenêtre
    if (fenetres.isEmpty()) {
      terminal.texte += "Aucune application ouverte.\n";
      return;
    }

    // Affichage des fenêtres
    terminal.texte += "Applications ouvertes (" + fenetres.size() + ") :\n";
    terminal.texte += "ID     | Application\n";
    terminal.texte += "-------|--------------------------------\n";

    for (Window w : fenetres) {
      terminal.texte +=
        nf(w.id, 5) + " | " + w.appli.getname() + "\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Afficher la liste des applications/fenêtres ouvertes avec leurs ID.\n" +
        "\n" +
        "Utilisation :\n" +
        "  top\n" +
        "\n" +
        "Exemple :\n" +
        "  top\n";
    }
    return "Afficher la liste des applications ouvertes avec leurs ID.";
  }
}

/*
 * Lancer un programme
 */
class CommandeRun implements Commande {

  void executer(String[] args, Terminal terminal) {
    // Aucun argument : afficher la liste des applications disponibles
    if (args.length == 0) {
      terminal.texte += "Applications disponibles :\n";
      for (String app : apps) {
        terminal.texte += "  - " + app + "\n";
      }
      terminal.texte +=
        "Utilisez \"run <nom_application>\" pour lancer une application.\n";
      return;
    }

    String nomApp = args[0];

    // Vérifier si l'application existe
    if (!estUneApp(nomApp)) {
      terminal.texte +=
        "Erreur : \"" + nomApp + "\" n'est pas une application existante.\n" +
        "Tapez \"run\" sans argument pour voir la liste des applications disponibles.\n";
      return;
    }

    // Lancer l'application
    float x = random(1.);
    float y = random(1.);
    creerApp(nomApp, new PVector(x, y)); // crée l'application

    terminal.texte +=
      "Lancement de l'application \"" + nomApp + "\"...\n";
  }

  String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return
        "Lance une application ou affiche la liste des applications disponibles.\n" +
        "Utilisation :\n" +
        "  run                 Affiche la liste des applications disponibles\n" +
        "  run <nom_app>       Lance l'application <nom_app>\n" +
        "Exemples :\n" +
        "  run\n" +
        "  run AppTest\n";
    }
    return "Lancer une application ou afficher la liste des applications disponibles.";
  }
}

class CommandeBase64 implements Commande {

  void executer(String[] args, Terminal terminal) {
    if (args.length < 2) {
      terminal.texte += "Utilisation : base64 encode <texte>\n";
      terminal.texte += "              base64 decode <texte_base64>\n";
      return;
    }

    String action = args[0];

    // reconstruire la chaîne à partir des arguments suivants
    StringBuilder sb = new StringBuilder();
    for (int i = 1; i < args.length; i++) {
      if (i > 1) sb.append(" ");
      sb.append(args[i]);
    }
    String input = sb.toString();

    if (action.equals("encode")) {
      String encoded = Base64.getEncoder()
        .encodeToString(input.getBytes(StandardCharsets.UTF_8));
      terminal.texte += encoded + "\n";
    } else if (action.equals("decode")) {
      try {
        byte[] decodedBytes = Base64.getDecoder().decode(input);
        String decoded = new String(decodedBytes, StandardCharsets.UTF_8);
        terminal.texte += decoded + "\n";
      }
      catch (IllegalArgumentException e) {
        terminal.texte += "Erreur : texte base64 invalide\n";
      }
    } else {
      terminal.texte += "Sous-commande inconnue : " + action + "\n";
      terminal.texte += "Utilisation : base64 encode <texte>\n";
      terminal.texte += "              base64 decode <texte_base64>\n";
    }
  }

  String getDescription(boolean avecExemples) {
    if (!avecExemples) {
      return "Encoder ou décoder du texte en base64";
    }
    return
      "Encoder ou décoder du texte en base64\n" +
      "Exemples :\n" +
      "  base64 encode Bonjour le monde\n" +
      "  base64 decode Qm9uam91ciBsZSBtb25kZQ==\n";
  }
}

class CommandeLisp implements Commande {

  public void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "Utilisation: lisp <expr>        → exécute une expression Lisp\n";
      terminal.texte += "             lisp load <chemin>  → charge un fichier Lisp depuis l'OS\n";
      return;
    }

    if (args[0].equals("load")) {
      if (args.length < 2) {
        terminal.texte += "Utilisation: lisp load <chemin>\n";
        return;
      }

      String chemin = args[1];

      // 1) nettoyer les guillemets
      if (chemin.length() >= 2 && chemin.startsWith("\"") && chemin.endsWith("\"")) {
        chemin = chemin.substring(1, chemin.length() - 1);
      }

      Node fichier = null;

      // 2) cas relatif : ./ ou ../ ou juste nom de fichier
      if (chemin.startsWith("./")) {
        String nom = chemin.substring(2);
        fichier = terminal.position.enfants.get(nom);
      } else if (chemin.startsWith("../")) {
        if (terminal.position.parent != null) {
          String nom = chemin.substring(3);
          fichier = terminal.position.parent.enfants.get(nom);
        }
      } else if (!chemin.startsWith("/")) {
        // chemin relatif au dossier courant
        fichier = terminal.position.enfants.get(chemin);
      } else {
        // chemin absolu /home/...
        fichier = chercherFichier(fichiers.racine, chemin, terminal);
      }

      if (fichier == null) {
        terminal.texte += "lisp load: fichier non trouvé " + chemin + "\n";
        return;
      }
      if (fichier.estDossier) {
        terminal.texte += "lisp load: impossible de charger un dossier " + chemin + "\n";
        return;
      }

      String contenu = fichier.contenu;
      if (contenu == null || contenu.isEmpty()) {
        terminal.texte += "lisp load: fichier vide " + chemin + "\n";
        return;
      }

      try {
        Object sexpr = parse("("+contenu+")");
        ArrayList<Object> exprs = (ArrayList<Object>)sexpr;
        for (Object exp : exprs) {
          lispEval(exp, terminal.lispEnv);
        }
        terminal.texte += "lisp load: fichier chargé " + chemin + "\n";
      }
      catch (Exception e) {
        terminal.texte += "Error (lisp load): " + e.getMessage() + "\n";
      }
      return;
    }

    // 3) sinon : évaluer une expression Lisp
    String lispCode = String.join(" ", args);
    try {
      Object res = lispEval(lispCode, terminal.lispEnv);
      if (res != null) {
        terminal.texte += " -> " + res.toString() + "\n";
      }
    }
    catch (Exception e) {
      terminal.texte += "Error (Lisp): " + e.getMessage() + "\n";
    }
  }

  public String getDescription(boolean avecExemples) {
    if (avecExemples) {
      return "exécuter ou charger des expressions LISP\n" +
        "          Exemples:\n" +
        "            lisp (+ 2 3 4)\n" +
        "            lisp (list 1 2 3)\n" +
        "            lisp load ./test.lisp";
    } else {
      return "exécuter ou charger des expressions LISP";
    }
  }
}
