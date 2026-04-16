/**
 * Programme crée par Nitnelav00 en 2025.
 */

/**
 * La classe Node représente un fichier ou un dossier présent dans l'OS
 * Le système de fichiers est représenté sous forme d'arbre
 */
class Node {
  String nom;              // Nom du fichier/dossier
  boolean estDossier;      // true = dossier, false = fichier
  Node parent;             // Référence vers le parent
  HashMap<String, Node> enfants; // Liste des enfants (uniquement pour les dossiers)
  String contenu = "";     // Contenu du fichier (inutile pour un dossier)

  Node(String nom, boolean dossier, Node parent) {
    this.nom = nom;
    this.estDossier = dossier;
    this.parent = parent;

    if (dossier) {
      this.enfants = new HashMap<String, Node>();
    } else {
      this.enfants = null; // Pas besoin d'enfants si c'est un fichier
      contenu = "";
    }
  }

  void ajouterEnfant(Node enfant) {
    if (estDossier && enfants != null) { // n'ajoute les enfants seulement si c'est un dossier
      enfant.parent = this;
      enfants.put(enfant.nom, enfant);
    }
  }

  void retirerEnfant(Node enfant) {
    if (estDossier && enfants != null) {
      enfants.remove(enfant.nom);
      enfant.parent = null;
    }
  }

  String listerEnfants() { // Liste les sous-dossiers
    String enf = "";
    for (Node e : enfants.values()) {
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

    if (parent != null && parent.estDossier && nom != "") {

      // Vérifie existence
      if (parent.enfants.containsKey(nom))
        return null;

      Node newNode = new Node(nom, estDossier, parent);
      parent.ajouterEnfant(newNode);

      return newNode;
    }
    return null;
  }

  String lireContenu(Node node) {
    if (node == null) return "";
    return node.contenu;
  }

  boolean modifierContenu(Node node, String contenu) {
    if (node == null) return false;
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
    if (estAncetre(node, nouveauParent)) return false;
    if (node.parent != null) {
      node.parent.retirerEnfant(node);
    }
    nouveauParent.ajouterEnfant(node);
    return true;
  }

  /**
   * La méthode tree permet d'afficher l'arbre des dossiers, fishiers et sous-dossiers présents dans le Node debut
   * Utilise un parcours en profondeur récursif
   */
  String tree(Node debut) {
    StringBuilder texte = new StringBuilder();
    treeRecursif(debut, "", texte);
    return texte.toString();
  }

  void treeRecursif(Node node, String prefixe, StringBuilder texte) {
    // Ligne actuelle
    String type = node.estDossier ? "[D]" : "[F]";
    texte.append(prefixe).append(type).append(" ").append(node.nom).append("\n");

    // Si pas d'enfants, s'arrêter
    if (node.enfants == null || node.enfants.isEmpty()) {
      return;
    }

    // Trier les enfants
    ArrayList<Node> enfants = new ArrayList<>(node.enfants.values());
    enfants.sort((a, b) -> a.nom.compareToIgnoreCase(b.nom));

    // Générer les branches CORRIGÉES
    for (int i = 0; i < enfants.size(); i++) {
      boolean dernier = (i == enfants.size() - 1);
      String connecteur = dernier ? "\\-- " : "|-- ";
      String nouveauPrefixe = prefixe + (dernier ? "    " : "|   ");

      treeRecursif(enfants.get(i), nouveauPrefixe + connecteur, texte);
    }
  }
  /**
   * Convertit tout le système en texte
   */
  String sauvegarderTexte() {
    if (racine == null) return "";

    String texte = "";
    ArrayList<Node> pile = new ArrayList<Node>();
    pile.add(racine);

    while (pile.size() > 0) {
      Node node = pile.remove(pile.size() - 1);

      // Ajoute les enfants à la pile
      if (node.enfants != null) {
        for (Node e : node.enfants.values()) {
          pile.add(e);
        }
      }

      String chemin = getChemin(node);

      // Remplace ';' pour éviter conflit
      chemin = chemin.replace(';', char(4));

      int isDir = node.estDossier ? 1 : 0;

      String contenu = Base64.getEncoder().encodeToString(node.contenu.getBytes(StandardCharsets.UTF_8)); // Sauvegarder en base64

      // Format : chemin;type;contenu
      texte += chemin + ";" + isDir + ";" + contenu + "\n";
    }

    return texte;
  }

  /**
   * La méthode sauvegarderTexte permet de charger l'ensemble des dossiers et fichiers depuis un texte
   */
  void chargerDepuisString(String[] lignes) {
    // on repart d'une racine propre
    racine = new Node("NitnelavOS", true, null);

    for (int i = 0; i < lignes.length; i++) {
      String ligne = lignes[i];
      if (ligne == null || ligne.trim().length() == 0) continue;

      String[] parts = ligne.split(";", 3);
      if (parts.length < 2) continue;

      String cheminComplet = parts[0];
      cheminComplet = cheminComplet.replace(char(4), ';'); // Même chause qu'à la sauvegarde mais à l'inverse
      boolean isDir = parts[1].equals("1");
      String contenu = parts.length == 3 ? parts[2] : "";
      contenu = contenu.length() > 0 ? new String(Base64.getDecoder().decode(contenu)) : ""; // Décoder la base64 pour charger

      if (cheminComplet.endsWith("/")) {
        cheminComplet = cheminComplet.substring(0, cheminComplet.length() - 1);
      }

      String[] segments = cheminComplet.split("/");
      if (segments.length == 0) continue;

      Node courant = racine; // segments[0] supposé être la racine

      for (int j = 1; j < segments.length; j++) {
        String nom = segments[j];
        boolean dernier = (j == segments.length - 1);

        Node existe = courant.enfants.get(nom);

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

Node chercherNodeParChemin(Node racine, String chemin, Terminal terminal) {
  if (chemin == null || chemin.isEmpty() || chemin.equals("/")) {
    return racine;
  }
  if (chemin.startsWith("/")) {
    chemin = chemin.substring(1);
  }

  // découper en segments
  String[] segments = chemin.split("/");
  return obtenirNode(racine, segments, segments.length, terminal);
}

Node chercherFichier(Node racine, String chemin, Terminal terminal) {
  if (chemin == null || chemin.isEmpty()) return null;

  String[] segments;
  if (chemin.startsWith("/")) {
    segments = chemin.substring(1).split("/");
  } else {
    segments = chemin.split("/");
  }

  if (segments.length == 0) return null;

  // le dernier segment est le nom du fichier
  String nomFichier = segments[segments.length - 1];
  int pos = chemin.length() - nomFichier.length();
  if (pos < 1) {
    terminal.texte += "Error (lisp load): chemin invalide pour " + chemin + "\n";
    return null;
  }

  String cheminDossier = chemin.substring(0, pos - 1);  // -1 pour le "/"

  Node nodeDossier = chercherNodeParChemin(racine, cheminDossier, terminal);
  if (nodeDossier == null || !nodeDossier.estDossier) {
    return null;
  }

  return nodeDossier.enfants.get(nomFichier);
}

// Sauvegarde dans un fichier texte
void sauvegarderLeSystemeDeFichier() {
  String data = fichiers.sauvegarderTexte();
  String[] lignes = split(data, '\n');
  saveStrings("data/sauvegarde.txt", lignes);
}

// Charge depuis un fichier texte
void chargerLeSystemeDeFichier() {
  String[] lignes = loadStrings("data/sauvegarde.txt");

  if (lignes == null) return;

  fichiers.chargerDepuisString(lignes);
}

boolean estDescendant(Node parent, Node enfant) {
  Node courant = parent;
  while (courant != null) {
    if (courant == enfant) return true;
    courant = courant.parent;
  }
  return false;
}

boolean estAncetre(Node a, Node b) {
  Node courant = b;
  while (courant != null) {
    if (courant == a) return true;
    courant = courant.parent;
  }
  return false;
}
