import java.util.Iterator;

final float MODEL_HEIGHT = 150;

ArrayList<CharaGraphics> charaGraphicsArray;

ArrayList<ArrayList<PointSet>> pointSetArray = new ArrayList<ArrayList<PointSet>>();

void setup() {
  charaGraphicsArray = new ArrayList<CharaGraphics>();
  charaGraphicsArray.add(new CharaGraphics("チョコ", true));
  charaGraphicsArray.add(new CharaGraphics("レート", false));

  int borderSize = charaGraphicsArray.get(0).borderPixelsOrderedKey.size();
  CharaGraphics cg1 = charaGraphicsArray.get(0);
  CharaGraphics cg2 = charaGraphicsArray.get(1);
  for (int i=0; i<borderSize-1; i++) {
    pointSetArray.add( new ArrayList<PointSet>() );
    int intervalPlot1 = cg1.borderPixelsOrderedKey.get(i).size()/100;
    int intervalPlot2 = cg2.borderPixelsOrderedKey.get(i).size()/100;

    int j1 = 0, j2 = 0;
    while (j1<cg1.borderPixelsOrderedKey.get(i).size() || j2<cg2.borderPixelsOrderedKey.get(i).size()) {
      if (j1>=cg1.borderPixelsOrderedKey.get(i).size()) j1 = cg1.borderPixelsOrderedKey.get(i).size()-1;
      if (j2>=cg2.borderPixelsOrderedKey.get(i).size()) j2 = cg2.borderPixelsOrderedKey.get(i).size()-1;

      Pixel popPixel1 = cg1.searchedBorderPixels.get( cg1.borderPixelsOrderedKey.get(i).get(j1) );
      Pixel popPixel2 = cg2.searchedBorderPixels.get( cg2.borderPixelsOrderedKey.get(i).get(j2) );
      pointSetArray.get(pointSetArray.size()-1).add(new PointSet(popPixel1, popPixel2));

      j1 += intervalPlot1;
      j2 += intervalPlot2;
    }
  }

  ArrayList<Triangle> triangles = new ArrayList<Triangle>();

  for (int i=0; i<pointSetArray.size(); i++) {
    ArrayList<PVector> topFace    = new ArrayList<PVector>();
    ArrayList<PVector> bottomFace = new ArrayList<PVector>();
    ArrayList<PointSet> stroke = pointSetArray.get(i);
    PointSet            end    = stroke.get(stroke.size()-1);

    Pixel pTop    = end.first.clone();
    Pixel pBottom = end.second.clone();

    for (int j=0; j<pointSetArray.get(i).size(); j++) {
      Pixel top    = pointSetArray.get(i).get(j).first;
      Pixel bottom = pointSetArray.get(i).get(j).second;

      triangles.add(new Triangle(
        new PVector(pBottom.x, 0, pBottom.y), 
        new PVector(pTop.x, MODEL_HEIGHT, pTop.y), 
        new PVector(top.x, MODEL_HEIGHT, top.y), 
        false, false
        ));

      triangles.add(new Triangle(
        new PVector(pBottom.x, 0, pBottom.y), 
        new PVector(bottom.x, 0, bottom.y), 
        new PVector(top.x, MODEL_HEIGHT, top.y), 
        true, true
        ));

      topFace.add(new PVector(top.x, MODEL_HEIGHT, top.y));
      bottomFace.add(new PVector(bottom.x, 0, bottom.y));

      pTop    = top.clone();
      pBottom = bottom.clone();
    }
    triangles.addAll(new Polygon(topFace).trianglate());

    ArrayList<Triangle> topFaceTriangles    = new Polygon(topFace).trianglate();
    ArrayList<Triangle> bottomFaceTriangles = new Polygon(bottomFace).trianglate();

    for (Iterator iterator = bottomFaceTriangles.iterator(); iterator.hasNext(); ) {
      Triangle triangle = ((Triangle) iterator.next());
      triangle.opposite();
      triangle.reverse();
    }

    triangles.addAll(topFaceTriangles);
    triangles.addAll(bottomFaceTriangles);
  }

  final float STICK_WEIGHT = 30;

  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2),  
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2),
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));
  triangles.add(new Triangle( 
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));

  triangles.add(new Triangle(
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));
  triangles.add(new Triangle( 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2),
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));

  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2),
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));    
  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));

  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));    
  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2),
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));

  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));
  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150-STICK_WEIGHT/2),
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150-STICK_WEIGHT/2)
    ));

  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2),
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));
  triangles.add(new Triangle(
    new PVector(  0, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2-STICK_WEIGHT/2, 150+STICK_WEIGHT/2), 
    new PVector(800, MODEL_HEIGHT/2+STICK_WEIGHT/2, 150+STICK_WEIGHT/2)
    ));

  outputFile(triangles, "chocolate.stl");

  shell(new StringList(), new StringList(), "open", sketchPath("chocolate.stl"));

  exit();
}