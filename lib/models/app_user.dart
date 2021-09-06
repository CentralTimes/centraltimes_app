class AppUser {
  final String email;
  final String uid;
  final String name;
  AppUser(this.email, this.uid, this.name);
  String get first => name.split(" ").first;
  String get last => name.split(" ").last;
}