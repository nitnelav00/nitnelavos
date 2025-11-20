

class Node {
  String nom;
  boolean estRepertoire;
  Node parent;
  ArrayList<Node> enfants;

  Node(String nom, boolean repertoire, Node parent) {
    this.nom = nom;
    this.estRepertoire = repertoire;
    this.parent = parent;

    if (repertoire) {
      this.enfants = new ArrayList<Node>();
    } else {
      this.enfants = null;
    }
  }

  void ajouterEnfant(Node enfant) {
    if (estRepertoire && enfants != null) {
      enfant.parent = this;
      enfants.add(enfant);
    }
  }

  void retirerEnfant(Node enfant) {
    if (estRepertoire && enfants != null) {
      enfants.remove(enfant);
      enfant.parent = null;
    }
  }

  String listerEnfants() {
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

  String getChemin(Node node) {
    if (node == null) return "";
    if (node.parent == null) return node.nom;
    return getChemin(node.parent) + "/" + node.nom;
  }

  Node creerNode(String nom, boolean estRepertoire, Node parent) {
    if (parent !=null && parent.estRepertoire && nom != "") {
      for (Node enfant : parent.enfants)
        if (enfant.nom.equals(nom))
          return null;
      Node newNode = new Node(nom, estRepertoire, parent);
      parent.ajouterEnfant(newNode);
      return newNode;
    }
    return null;
  }

  void supprimerNode(Node node) {
    if (node != null && node.parent != null) {
      node.parent.retirerEnfant(node);
    }
  }

  boolean deplacerNode(Node node, Node nouveauParent) {
    if (node == null || nouveauParent == null || !nouveauParent.estRepertoire) {
      return false;
    }
    if (node.parent != null) {
      node.parent.retirerEnfant(node);
    }
    nouveauParent.ajouterEnfant(node);
    return true;
  }
}
