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
    if (args.length != 0) {
      for (String nomCommande : args) {
        Commande cmd = terminal.commandes.get(nomCommande);
        if (cmd == null) {
          terminal.texte += "La commande " + nomCommande + " n'existe pas.\n";
        } else {
          terminal.texte += nomCommande + " : " + cmd.getDescription(true) + "\n\n";
        }
      }
      return;
    }
    terminal.texte += "Commandes disponibles :\n";
    // Parcours toutes les comandes
    for (String nomCommande : terminal.commandes.keySet()) {
      Commande cmd = terminal.commandes.get(nomCommande);
      terminal.texte += nomCommande + " : " + cmd.getDescription(false) + "\n";
    }
    terminal.texte += "\n";
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples)
      return "Affiche la description des commandes.\nSi une commande est passée en argumment,\nelle aura une description plus précise\nExemple : help help\n";
    return "Affiche la description des commandes.";
  };
}

/*
 * Commande pour netoyer l'affichage du terminal
 */
class CommandeClear implements Commande {
  void executer(String[] args, Terminal terminal) {
    terminal.texte = "";
  }
  String getDescription(boolean avecExemples) {
    return "Vide le texte de l'affichage";
  }
}

/*
 * Commande pour quitter le terminal
 */
class CommandeExit implements Commande {
  void executer(String[] args, Terminal terminal) {
    detruire(terminal.id);
  }
  String getDescription(boolean avecExemples) {
    return "Ferme le terminal";
  }
}

/*
 * Commande pour quitter l'OS
 */
class CommandeShutdown implements Commande {
  void executer(String[] args, Terminal terminal) {
    exit();
  }
  String getDescription(boolean avecExemples) {
    return "Quitte l'OS entièrement";
  }
}

/*
 * Commande pour détruire les applications à distance
 */
class CommandeKill implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "La commande kill doit avoir l'ID (un entier) de la fenetre à fermer en argument";
      return;
    }
    for (String id : args) {
      try {
        detruire(Integer.parseInt(id));
      }
      catch (NumberFormatException e) {
        terminal.texte += "Erreur : " + id + "n'est pas un entier\n";
      }
    }
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples) return "Ferme la fenêtre d'une application grâce à son ID\nIl est possible d'en mettre plusieurs à la fois\nExemple : kill 1 2 3";
    return "Ferme la fenêtre d'une application (avec son ID)";
  }
}

/*
 * Commande pour afficher les applications présentes à l'écran
 */
class CommandeTop implements Commande {
  void executer(String[] args, Terminal terminal) {
    for (Window w : fenetres) {
      terminal.texte += "Id : "+ str(w.id) + " | nom :\""+w.appli.getname()+"\"\n";
    }
  }
  String getDescription(boolean avecExemples) {
    return "Affiche toutes les applications ouvertes avec leur ID";
  }
}

/*
 * Lancer un programme
 */
class CommandeRun implements Commande {
  void executer(String[] args, Terminal terminal) {
    if (args.length == 0) {
      terminal.texte += "Application disponibles :\n";
      for (String app : apps) {
        terminal.texte += app + "  ";
      }
      terminal.texte += "\n";
      return;
    }
    if (!estUneApp(args[0]))
      terminal.texte += args[0] + " n'est pas une application existante\n";
    else {
      float x=random(1.);
      float y=random(1.);
      creerApp(args[0], new PVector(x, y)); // crée l'application
    }
  }
  String getDescription(boolean avecExemples) {
    if (avecExemples) return "Si un argument est donné, le programme correspondant sera lancé\nSans aucun argument, la liste des applications s'affiche\nExemple : run AppTest";
    return "Lance un programme donné, sinon liste les programmes existants";
  }
}
