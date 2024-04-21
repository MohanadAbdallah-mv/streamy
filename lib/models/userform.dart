
class FormUser {
  String? name;
  String? phonenumber;
  String email;
  String password;

  FormUser(
      {this.name,
        required this.email,
        required this.password,this.phonenumber});
}