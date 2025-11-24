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

  Node(String nom, boolean dossier, Node parent) {
    this.nom = nom;
    this.estDossier = dossier;
    this.parent = parent;

    if (dossier) {
      this.enfants = new ArrayList<Node>();
    } else {
      this.enfants = null; // Pas besoin d'enfants si c'est un fichier
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
      for (Node e : node.enfants)
        nodes.add(e);
      texte += getChemin(node) + "\n";
    }
    return texte;
  }
}
