class User {
  String? name;
  String? phoneNum;
  String? email;
  String? address;
  String? password;

  User(
      {this.name,
      this.phoneNum,
      this.email,
      this.address,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNum = json['phoneNum'];
    email = json['email'];
    address = json['address'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNum'] = phoneNum;
    data['email'] = email;
    data['address'] = address;
    data['password'] = password;
    return data;
  }
}