class Market {
  final String name;
  final double debt;

  Market({this.name, this.debt});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'debt': debt.toString(),
    };
  }
}
