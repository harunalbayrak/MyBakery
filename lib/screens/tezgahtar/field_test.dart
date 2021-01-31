class fieldTest {
  static String veresiyeContentValidator(String text) {
    print("inside validator");
    if (text.isEmpty) return "Miktar kısmı boş bırakılamaz!";

    Pattern pattern = r"^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(text)) return "Miktar bilgisi numerik olmalıdır!";
  }

  static String veresiyeTitleValidator(String text) {
    if (text.isEmpty) return "Veresiye Sahibi bilgisi boş bırakılamaz!";
  }

  static String expenseTitleValidator(String text) {
    print("inside validator");
    if (text.isEmpty) return "Gider kısmı boş bırakılamaz!";

    Pattern pattern = r"^[1-9]?([1-9]\d*)";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(text)) {
      print("not a number");
      return "Gider bilgisi numerik olmalıdır!";
    }
  }

  static String expenseContentValidator(String text) {
    if (text.isEmpty) return "Not bilgisi boş bırakılamaz!";
  }

  static String noteValidator(String text) {
    if (text.isEmpty) return "Not bilgisi boş bırakılamaz!";
  }
}
