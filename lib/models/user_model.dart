class MyUser {
  late String id;
  late String? name;
  late String email;
  late String? phonenumber;
  late bool isLogged; //online status
  late String? profilePicture;
  String role = "user";

  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phonenumber,
      required this.isLogged,
      this.profilePicture,
      required this.role});

  MyUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    isLogged = json["isLogged"];
    profilePicture = json["Profile_Picture"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    //var ordersMap=orders!.map((e)=>e.toJson()).toList();
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phonenumber,
      "Profile_Picture": profilePicture,
      "isLogged": isLogged,
      "role": role
    };
  }
}
