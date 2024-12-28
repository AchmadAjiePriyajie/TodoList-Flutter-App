class AppUser {
  String uid;
  String username;
  String email;

  // Constructor untuk menginisialisasi variabel instance
  AppUser({
    required this.uid,
    required this.username,
    required this.email,
  });

  // Method untuk mengubah data user menjadi map (misalnya untuk penyimpanan atau API)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }

  // Factory constructor untuk membuat user dari map (misalnya untuk parsing data JSON)
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
    );
  }
}
