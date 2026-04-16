/**
 * Programme crée par Nitnelav00 en 2026.
 */

/**
 * La classe Rect sert à créer des rectangles et à tester les collisions
 */
class Rect {
  float x, y, w, h;
  boolean centre;
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    centre = false;
  }
  Rect(float x, float y, float w, float h, boolean depuisLeCentre) { // Si le rectangle doit être centré, mettre depuis Centre à True
    if (depuisLeCentre) {
      this.x = x - w/2;
      this.y = y - h/2;
      this.w = w;
      this.h = h;
    } else {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }
    centre = depuisLeCentre;
  }

  boolean collision(Rect autre) { // collision avec un autre rectangle
    return this.x <= autre.x + autre.w &&
      this.x + this.w >= autre.x &&
      this.y <= autre.y + autre.h &&
      this.y + this.h >= autre.y;
  }

  void draw(PGraphics pg) {
    pg.rect(x, y, w, h);
  }

  // Getters
  float getX() {
    if (centre)
      return x + w/2;
    else
      return x;
  }
  float getY() {
    if (centre)
      return y + h/2;
    else
      return y;
  }

  // Setters
  void setX(float nouveauX) {
    if (centre)
      x = nouveauX - w/2;
    else
      x = nouveauX;
  }
  void setY(float nouveauY) {
    if (centre)
      y = nouveauY - h/2;
    else
      y = nouveauY;
  }
}
