
void sauvegarderLeSystemeDeFichier() {
  String data = fichiers.sauvegarderTexte();
  String[] lignes = split(data, '\n');
  saveStrings("data/sauvegarde.txt", lignes);
}

void chargerLeSystemeDeFichier() {
  String[] lignes = loadStrings("data/sauvegarde.txt");
  if (lignes == null) return;


  String data = join(lignes, "\n");
  fichiers.chargerDepuisString(data); // méthode dans SystemFichiers
}
