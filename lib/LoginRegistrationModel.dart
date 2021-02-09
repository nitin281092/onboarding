class LoginModel {
  String email;
  String password;
  LoginModel({this.email, this.password});
  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class RegistrationModel {
  String name;
  String email;
  String password;
  RegistrationModel({this.name, this.email, this.password});
  RegistrationModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
