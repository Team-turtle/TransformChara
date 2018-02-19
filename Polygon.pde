class Polygon {
  ArrayList<PVector> vertex;

  Polygon(ArrayList<PVector> _v) {
    this.vertex = new ArrayList<PVector>(_v);
  }

  // use only X-Z plane
  ArrayList<Triangle> trianglate() {
    ArrayList<PVector> pool = new ArrayList<PVector>(this.vertex);
    ArrayList<Triangle> triangles = new ArrayList<Triangle>();
    Triangle addition;
    while (pool.size() > 3) {
      float maxDist   = pool.get(0).mag();
      int   targetArg = 0;
      for (int i = 1; i < pool.size(); i++) {
        if (pool.get(i).mag() > maxDist) {
          maxDist   = pool.get(i).mag();
          targetArg = i;
        }
      }
      PVector parentCross = PVector.sub(pool.get((targetArg+pool.size()-1) % pool.size()), pool.get((targetArg)))
        .cross(PVector.sub(pool.get((targetArg+1) % pool.size()), pool.get((targetArg)))).normalize();
      addition = new Triangle(
        pool.get((targetArg+pool.size()-1) % pool.size()), 
        pool.get((targetArg)), 
        pool.get((targetArg+1) % pool.size())
        );
      boolean existsIncludePoint = false;
      for (int i = 0; i < pool.size(); i++) {
        if (i == (targetArg+pool.size()-1) % pool.size() || i == targetArg || i == (targetArg+1) % pool.size()) continue;
        if (addition.include(pool.get(i))) {
          existsIncludePoint = true;
          break;
        }
      }
      if (!existsIncludePoint) {
        triangles.add(addition);
        pool.remove(targetArg);
        continue;
      }
      int startArg = targetArg;
      while (true) {
        targetArg = (targetArg+1) % pool.size();
        if (targetArg == startArg) return triangles;
        PVector childCross = PVector.sub(pool.get((targetArg+pool.size()-1) % pool.size()), pool.get((targetArg)))
          .cross(PVector.sub(pool.get((targetArg+1) % pool.size()), pool.get((targetArg)))).normalize();
        if (parentCross.y == childCross.y) {
          addition = new Triangle(
            pool.get((targetArg+pool.size()-1) % pool.size()), 
            pool.get((targetArg)), 
            pool.get((targetArg+1) % pool.size())
            );
          existsIncludePoint = false;
          for (int i = 0; i < pool.size(); i++) {
            if (i == (targetArg+pool.size()-1) % pool.size() || i == targetArg || i == (targetArg+1) % pool.size()) continue;
            if (addition.include(pool.get(i))) {
              existsIncludePoint = true;
              break;
            }
          }
          if (!existsIncludePoint) {
            triangles.add(addition);
            pool.remove(targetArg);
            break;
          }
        }
      }
    }
    triangles.add(new Triangle(pool.get(0), pool.get(1), pool.get(2)));
    return triangles;
  }
}