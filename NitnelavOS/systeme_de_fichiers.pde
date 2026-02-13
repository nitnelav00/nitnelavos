/**
 * Programme crée par Couard Añó Presencía Valentin, L1 MIPSI en 2025.
 */

/**
 * La classe Node représente un fichier ou un dossier présent dans l'OS
 * Le système de fichiers est représenté sous forme d'arbre
 */
class Node {
  String nom;
  boolean estDossier; // si true c'est un dossier, sinon c'est un dossier
  Node parent; // le parent
  ArrayList<Node> enfants; // Les enfants si c'est un dossier
  String contenu = "";

  Node(String nom, boolean dossier, Node parent) {
    this.nom = nom;
    this.estDossier = dossier;
    this.parent = parent;

    if (dossier) {
      this.enfants = new ArrayList<Node>();
    } else {
      this.enfants = null; // Pas besoin d'enfants si c'est un fichier
      contenu = "";
    }
  }

  void ajouterEnfant(Node enfant) {
    if (estDossier && enfants != null) { // n'ajoute les enfants seulement si c'est un dossier
      enfant.parent = this;
      enfants.add(enfant);
    }
  }

  void retirerEnfant(Node enfant) {
    if (estDossier && enfants != null) {
      enfants.remove(enfant);
      enfant.parent = null;
    }
  }

  String listerEnfants() { // Liste les sous-dossiers
    String enf = "";
    for (Node e : enfants) {
      enf += e.nom + "    ";
    }
    return enf;
  }
}

class SystemFichiers {
  Node racine;

  SystemFichiers(String nomRacine) {
    racine = new Node(nomRacine, true, null);
  }

  /**
   * Retourne le chemin sous la forme :
   * racine/dossier1/dossier2/fichier
   */
  String getChemin(Node node) {
    if (node == null) return "";
    if (node.parent == null) return node.nom + "/";
    if (node.estDossier)
      return getChemin(node.parent) + node.nom + "/";
    return getChemin(node.parent) + node.nom;
  }

  /**
   * Crée un fichier ou dossier avec le nom @nom dans le dossier @parent
   */
  Node creerNode(String nom, boolean estDossier, Node parent) {
    if (parent !=null && parent.estDossier && nom != "") { // vérifier si le parent est un dossier
      for (Node enfant : parent.enfants) // vérifier que le fichier ou dossier n'éxiste pas encore
        if (enfant.nom.equals(nom))
          return null;
      Node newNode = new Node(nom, estDossier, parent);
      parent.ajouterEnfant(newNode); // l'ajouter aux enfants s'il est crée
      return newNode;
    }
    return null;
  }
  
  String lireContenu(Node node) {
    return node.contenu;
  }
  
  boolean modifierContenu(Node node, String contenu) {
    if (node.estDossier)
      return false;
    node.contenu = contenu;
    return true;
  }

  void supprimerNode(Node node) {
    if (node != null && node.parent != null) {
      node.parent.retirerEnfant(node);
    }
  }

  // retourne faux s'il n'a pas réussi à le déplacer
  boolean deplacerNode(Node node, Node nouveauParent) {
    if (node == null || nouveauParent == null || !nouveauParent.estDossier) { // ne peux déplacer le Node que si le nouveau parent est un dossier
      return false;
    }
    if (node.parent != null) {
      node.parent.retirerEnfant(node);
    }
    nouveauParent.ajouterEnfant(node);
    return true;
  }
  
  /**
   * La méthode tree permet d'afficher l'arbre des dossiers, fishiers et sous-dossiers présents dans le Node debut
   * Utilise un parcours en profondeur
   */
  String tree(Node debut){
    String texte = "";
    ArrayList<Node> nodes = new ArrayList();
    nodes.add(debut);
    while (nodes.size() > 0) {
      Node node = nodes.remove(nodes.size()-1);
      if (node == null || node.enfants == null) continue; // protection
      for (Node e : node.enfants)
        nodes.add(e);
      texte += getChemin(node) + "\n";
    }
    return texte;
  }
  
  /**
   * La méthode sauvegarderTexte permet de sauvegarder l'ensemble des dossiers et fichiers au format texte
   */
  String sauvegarderTexte() {
    if (racine == null) return "";
    String texte = "";
    ArrayList<Node> pile = new ArrayList<Node>();
    pile.add(racine);
    while (pile.size() > 0) {
      Node node = pile.remove(pile.size() - 1);
      if (node.enfants != null) {
        for (Node e : node.enfants) {
          pile.add(e);
        }
      }
      String chemin = getChemin(node);
      chemin = chemin.replace(";", "§"); // Les séparateurs sont des ";" alors on remplace les ";" par des "§"
      int isDir = node.estDossier ? 1 : 0;
      String contenu = "";
      if (!node.estDossier && node.contenu != null) {
        contenu = node.contenu.replace("\n", "\\n");
      }
      texte += chemin + ";" + isDir + ";" + contenu + "\n";
    }
    return texte;
  }

  /**
   * La méthode sauvegarderTexte permet de charger l'ensemble des dossiers et fichiers depuis un texte
   */
  void chargerDepuisString(String data) {
    // on repart d'une racine propre
    racine = new Node("NitnelavOS", true, null);

    String[] lignes = data.split("\n");
    for (int i = 0; i < lignes.length; i++) {
      String ligne = lignes[i];
      if (ligne == null || ligne.trim().length() == 0) continue;

      String[] parts = ligne.split(";", 3);
      if (parts.length < 2) continue;

      String cheminComplet = parts[0];
      cheminComplet = cheminComplet.replace("§", ";");
      boolean isDir = parts[1].equals("1");
      String contenu = parts.length == 3 ? parts[2] : "";
      contenu = contenu.replace("\\n", "\n");

      if (cheminComplet.endsWith("/")) {
        cheminComplet = cheminComplet.substring(0, cheminComplet.length() - 1);
      }

      String[] segments = cheminComplet.split("/");
      if (segments.length == 0) continue;

      Node courant = racine; // segments[0] supposé être la racine

      for (int j = 1; j < segments.length; j++) {
        String nom = segments[j];
        boolean dernier = (j == segments.length - 1);

        Node existe = null;
        if (courant.enfants != null) {
          for (Node e : courant.enfants) {
            if (e.nom.equals(nom)) {
              existe = e;
              break;
            }
          }
        }

        if (dernier) {
          if (existe == null) {
            Node nouveau = creerNode(nom, isDir, courant);
            if (!isDir && nouveau != null) {
              modifierContenu(nouveau, contenu);
            }
          } else {
            if (!existe.estDossier) {
              modifierContenu(existe, contenu);
            }
          }
        } else {
          if (existe == null) {
            existe = creerNode(nom, true, courant);
          }
          courant = existe;
        }
      }
    }
  }
}
