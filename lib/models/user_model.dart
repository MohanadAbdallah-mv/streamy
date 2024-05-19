class MyUser {
  late String id;
  late String? name;
  late String email;
  late String? phonenumber;
  late bool isLogged; //online status
  late String? profilePicture;
  late List<String>? friends;
  String role = "user";

  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phonenumber,
      required this.isLogged,
      this.profilePicture,
        this.friends,
      required this.role});

  MyUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    isLogged = json["isLogged"];
    profilePicture = json["Profile_Picture"];
    role = json["role"];
    friends=json["friends"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phonenumber,
      "Profile_Picture": profilePicture,
      "isLogged": isLogged,
      "role": role,
      "friends":friends,
    };
  }
}
