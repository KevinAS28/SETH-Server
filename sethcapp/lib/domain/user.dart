class User {
  int id;
  String name;
  String nik;
  String email;
  String phone;
  String username;
  String password;

  User(
      {this.id,
      this.name,
      this.nik,
      this.email,
      this.phone,
      this.username,
      this.password,
      });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['id'],
        name: responseData['name'],
        nik: responseData['nik'],
        email: responseData['email'],
        phone: responseData['phone'],
        username: responseData['username'],
        password: responseData['password']
    );
  }
}
