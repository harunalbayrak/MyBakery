class Category {
  final String name;
  final String image;

  const Category({this.name, this.image});

  Map<String, dynamic> toMap() {
    Map deneme = {
      "name": "deneme",
      "price": 1,
    };
    return {"deneme": deneme};
  }
}
