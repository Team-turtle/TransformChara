class Triangle {

  PVector[] vertex;
  PVector normal;

  Triangle() {
    this.vertex = new PVector [3];
    this.vertex[0] = new PVector(-1, -1);
    this.vertex[1] = new PVector(-1, -1);
    this.vertex[2] = new PVector(-1, -1);
  }

  Triangle(PVector p1, PVector p2, PVector p3, boolean rev, boolean opp) {
    this.vertex = new PVector [3];
    this.vertex[0] = new PVector(p1.x, p1.y, p1.z);
    this.vertex[1] = new PVector(p2.x, p2.y, p2.z);
    this.vertex[2] = new PVector(p3.x, p3.y, p3.z);
    calcNormal();
    if (rev) this.reverse();
    if (opp) this.opposite();
  }

  Triangle(PVector p1, PVector p2, PVector p3) {
    this(p1, p2, p3, false, false);
  }

  Triangle(Triangle origin) {
    this.vertex = new PVector [3];
    arrayCopy(origin.vertex, this.vertex);
    calcNormal();
  }

  void opposite() {
    PVector temp = this.vertex[1];
    this.vertex[1] = this.vertex[2];
    this.vertex[2] = temp;
  }

  void reverse() {
    this.normal.mult(-1);
  }

  void calcNormal() {
    this.normal = PVector.sub(this.vertex[1], this.vertex[0]).cross(PVector.sub(this.vertex[2], this.vertex[1])).normalize();
  }

  boolean equals(Triangle t) {
    return (this.vertex[0].equals(t.vertex[0]) && this.vertex[1].equals(t.vertex[1]) && this.vertex[2].equals(t.vertex[2]))
      || (this.vertex[0].equals(t.vertex[0]) && this.vertex[1].equals(t.vertex[2]) && this.vertex[2].equals(t.vertex[1]))
      || (this.vertex[0].equals(t.vertex[1]) && this.vertex[1].equals(t.vertex[0]) && this.vertex[2].equals(t.vertex[2]))
      || (this.vertex[0].equals(t.vertex[1]) && this.vertex[1].equals(t.vertex[2]) && this.vertex[2].equals(t.vertex[0]))
      || (this.vertex[0].equals(t.vertex[2]) && this.vertex[1].equals(t.vertex[0]) && this.vertex[2].equals(t.vertex[1]))
      || (this.vertex[0].equals(t.vertex[2]) && this.vertex[1].equals(t.vertex[1]) && this.vertex[2].equals(t.vertex[0]));
  }

  // use only X-Z plane
  boolean include(PVector target) {
    PVector cross1 = PVector.sub(this.vertex[1], this.vertex[0]).cross(PVector.sub(target, this.vertex[1])).normalize();
    PVector cross2 = PVector.sub(this.vertex[2], this.vertex[1]).cross(PVector.sub(target, this.vertex[2])).normalize();
    PVector cross3 = PVector.sub(this.vertex[0], this.vertex[2]).cross(PVector.sub(target, this.vertex[0])).normalize();
    return cross1.y == cross2.y && cross2.y == cross3.y;
  }

  void draw() {
    beginShape();
    vertex(this.vertex[0].x, this.vertex[0].y, this.vertex[0].z);
    vertex(this.vertex[1].x, this.vertex[1].y, this.vertex[1].z);
    vertex(this.vertex[2].x, this.vertex[2].y, this.vertex[2].z);
    endShape(CLOSE);
  }

  String toString() {
    return "  vertex " + this.vertex[0].x + " " + this.vertex[0].y + " " + this.vertex[0].z + "\n"
      + "  vertex " + this.vertex[1].x + " " + this.vertex[1].y + " " + this.vertex[1].z + "\n"
      + "  vertex " + this.vertex[2].x + " " + this.vertex[2].y + " " + this.vertex[2].z;
  }
}