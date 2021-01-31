class Product {
  final String name;
  final String category;
  final double amount;

  const Product({this.name, this.amount, this.category});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': amount,
    };
  }
}
