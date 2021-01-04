class Payer {
  final String name;
  final double debt;
  DateTime date = DateTime.now();
  Payer({this.name, this.debt});

  Map<String, dynamic> toMap() {
    return {
      'title': name,
      'content': debt.toString(),
      'date': date.toIso8601String(),
    };
  }
}
