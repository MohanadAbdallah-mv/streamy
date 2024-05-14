class MyUser {
  late String id;
  late String? name;
  late String email;
  late String? phonenumber;
  late bool isLogged;
  String role = "user";

  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phonenumber,
      required this.isLogged,
      required this.role});

  MyUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    isLogged = json["isLogged"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    //var ordersMap=orders!.map((e)=>e.toJson()).toList();
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phonenumber,
      "isLogged": isLogged,
      "role": role
    };
  }
}
