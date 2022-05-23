class Registration {
  String? name;
  String? phoneNum;
  String? email;
  String? address;
  String? password;

  Registration(
      {this.name,
      this.phoneNum,
      this.email,
      this.address,
      this.password});

  Registration.fromJson(Map<String, dynamic> json) {
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