class Category {
  final String name;
  final String image;

  const Category({this.name, this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
