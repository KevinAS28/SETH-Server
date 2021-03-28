class User {
  int id = 0;
  String name = "Name";
  String nik;
  String email = "myemail@gmail.com";
  String phone = "+62 0123 456 789";
  String username;
  String password;

  User(
      {
      this.nik,
      this.username,
      this.password,
      
      this.id,
      this.name,

      this.email,
      this.phone,
      });
  
  User.minimal({this.nik, this.username, this.password});
  

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

  factory User.fromJsonMinimal(Map<String, dynamic> responseData) {
    return User(
        id: -1,
        name: 'Name',
        nik: responseData['nik'],
        email: 'myemail@gmail.com',
        phone: '+62 8241840',
        username: responseData['username'],
        password: responseData['password']
    );
  }
}
