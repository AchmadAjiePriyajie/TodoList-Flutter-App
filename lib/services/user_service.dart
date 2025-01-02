import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/app_user.dart';

class UserService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<AppUser?> getUserByUid(String uid) async {
    try {
      // Query the users collection by UID
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Convert the document data into an AppUser object
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return AppUser.fromMap(
            userData); // Assuming you have a fromMap method in AppUser
      } else {
        return null; // User not found
      }
    } catch (e) {
      return null;
    }
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    // Return the current user as AppUser
    return await getUserByUid(firebaseUser.uid);
  }

  Future<AppUser?> registerWithEmailPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());
      return user;
    } catch (e) {
      throw Exception('register failed: $e');
    }
  }

  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser? user = await getUserByUid(userCredential.user!.uid);

      return user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  Future<List<AppUser>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection('users').get();

      // Mapping hasil query ke list AppUser
      List<AppUser> userList = querySnapshot.docs.map((doc) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return userList;
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
