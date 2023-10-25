class User {
  String id;
  String username;
  String storename;
  String password;

  User({
    required this.id,
    required this.username,
    required this.storename,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic>? data) {
    return User(
      id: data?['id'],
      username: data?['username'],
      storename: data?['storename'],
      password: data?['password'],
    );
  }
}
