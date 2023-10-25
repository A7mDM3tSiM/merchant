class User {
  String id;
  String name;
  String password;

  User(
    this.id,
    this.name,
    this.password,
  );

  factory User.fromMap(Map<String, dynamic>? data) {
    return User(data?['id'], data?['name'], data?['password']);
  }
}
