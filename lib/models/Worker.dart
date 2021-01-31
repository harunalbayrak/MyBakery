class Worker {
  final String name;
  final String mail;
  final String job;
  String password;

  Worker({this.name, this.mail, this.job, this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mail': mail,
      'job': job,
      'passwd': password,
    };
  }
}
