/**
 * Programme crée par Nitnelav00 en 2026.
 */

PImage fondFlappy; // Le fond qui défile
PImage solFlappy;
PImage tuyauFlappy;
PImage joueurFlappy;

/*
 * La classe Tuyau est utilisé pour créer et déplacer les tuyau dans le jeu
 */
class Tuyau {
  PVector pos;
  int centreTuyau;
  Rect haut; // Le tuyau du haut
  Rect bas; // le tuyau du bas
  final int DISTANCE_ENTRE_CENTRE_ET_TUYAU = 55;

  Tuyau(float positionDepart) {
    centreTuyau = -tuyauFlappy.height / 2; // calculer le centre de la texture du tuyau

    pos = new PVector(positionDepart, centreTuyau / 2); // Centrer le tuyau
    haut = new Rect(pos.x + 5, pos.y, tuyauFlappy.width - 10, -centreTuyau - DISTANCE_ENTRE_CENTRE_ET_TUYAU); // calculer le rectangle du haut
    bas = new Rect(pos.x, pos.y -centreTuyau + DISTANCE_ENTRE_CENTRE_ET_TUYAU, tuyauFlappy.width - 10, -centreTuyau - DISTANCE_ENTRE_CENTRE_ET_TUYAU); // calculer le rectangle du bas
    pos.y = constrain(randomGaussian() * centreTuyau/5 + centreTuyau/2, centreTuyau/2, - centreTuyau/2); // Déplacer le tuyau aléatoirement en restant vers le centre

    // centrer les collisions
    haut.setY(pos.y);
    bas.setY(pos.y -centreTuyau + 55);
  }

  // Mettre à jour le tuyau et renvoyer true si le tuyau atteint le bord de l'écran
  boolean update(float vitesse, float width) {
    pos.x -= vitesse;
    boolean ajouter = false;

    if (pos.x < -tuyauFlappy.width) { // Calculer si le tuyau sort de l'écran
      pos.x = width;
      pos.y = constrain(randomGaussian(), -1, 1) * centreTuyau/4 + centreTuyau/3; // mettre la position à une position aléatoire vers le centre
      // recalculer la position des deux rectangles
      haut.setY(pos.y);
      bas.setY(pos.y -centreTuyau + DISTANCE_ENTRE_CENTRE_ET_TUYAU);
      ajouter = true;
    }
    haut.x = bas.x = pos.x + 5;
    return ajouter;
  }

  void draw(PGraphics pg) {
    pg.image(tuyauFlappy, pos.x, pos.y); // dessiner les tuyaux
  }

  boolean collision(Rect joueur) {
    return haut.collision(joueur) || bas.collision(joueur); // vérifier si il y a une collision avec le joueur
  }
}

/*
 * Flappy est une application graphique
 * C'est un jeu comme FlappyBird mais avec une pomme de terre à la place de l'oiseau
 */
class Flappy implements GUIApp {
  int id;
  float position;
  int width;
  int height;
  // Il n'y a besoin que de deux tuyaux
  Tuyau tuyau0;
  Tuyau tuyau1;
  int score;

  Rect joueur;
  float vy;

  final float JUMP_POWER = 4;
  final float GRAVITE = .2;

  String getname() {
    return "Flappy potato   Score : " + score; // afficher le titre avec le score du joueur
  }

  PVector setup(int id) {
    width = 360;
    height = 640;
    score = 0;
    joueur = new Rect(20, height/2, joueurFlappy.width, joueurFlappy.height, true);
    position = 0;
    vy = 0;
    tuyau0 = new Tuyau(width);
    tuyau1 = new Tuyau(width + width/1.7);
    this.id = id;
    return new PVector(width, height); // renvoie la taille de la fenêtre
  }

  void update(PVector mouse, PVector pmouse, PVector taille, boolean focus) {
    position -= 1;
    joueur.y += vy;
    vy += GRAVITE;

    if (click) { // si on clique, la pome de terre vas vers le haut
      vy = -JUMP_POWER;
    }
    if (tuyau0.update(1, width)) score++;
    if (tuyau1.update(1, width)) score++;
  }

  void draw(PGraphics pg, float width, float height) {
    if (position % 3 == 0)
      return;
    pg.image(fondFlappy, (position*.7)%width, 0);
    pg.image(fondFlappy, (position*.7)%width + width, 0);

    // Faire tourner le sprite du joueur quand il tombe
    pg.push();
    pg.imageMode(CENTER);
    pg.translate(joueur.getX(), joueur.getY());
    pg.rotate(constrain(vy/4, -QUARTER_PI, HALF_PI-.2));
    pg.image(joueurFlappy, 0, 0);
    pg.pop();

    tuyau0.draw(pg);
    tuyau1.draw(pg);
    if (tuyau0.collision(joueur) || tuyau1.collision(joueur) || joueur.y + joueur.h > height) { // s'il y a une collision, recomencer la partie
      position = 0;
      tuyau0 = new Tuyau(width);
      tuyau1 = new Tuyau(width + width/1.7);
      score = 0;
      joueur.y = height/2;
      vy = 0;
    }

    pg.image(solFlappy, position%width, 0);
    pg.image(solFlappy, position%width + width, 0);
  }
}
