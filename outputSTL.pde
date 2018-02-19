// 三角形をSTL出力に変換

// STLファイルの最初に
// solid 任意の文字列
// STLファイルの最後に
// endsolid 任意の文字列
// をつけること

String outputSTL(Triangle t) {
  return "facet normal " + t.normal.x + " " + t.normal.y + " " + t.normal.z + "\n" + " outer loop\n" + t.toString() + "\n endloop\nendfacet\n";
}

void outputFile(ArrayList<Triangle> _triangles, String fileName) {
  String[] str = {"solid team_turtle"};
  for (Triangle triangle : _triangles) {
    str = append(str, outputSTL(triangle));
  }
  str = append(str, "endsolid team_turtle");
  saveStrings(fileName, str);
}