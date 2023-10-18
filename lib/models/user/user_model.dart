class User {
  int id;
  String name;
  String password;

  late String createdAt;
  late String updatedAt;

  User(
    this.id,
    this.name,
    this.password, {
    String? createdAt,
    String? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now().toString();
    this.updatedAt = updatedAt ?? DateTime.now().toString();
  }
}
