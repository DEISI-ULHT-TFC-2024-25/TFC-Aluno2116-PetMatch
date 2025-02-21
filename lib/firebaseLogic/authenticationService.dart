import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authenticationservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 REGISTAR UTILIZADOR
  Future<User?> registerUtilizador(String email, String password, Map<String, dynamic> userData) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection("utilizador").doc(user.uid).set(userData);
      }

      return user;
    } catch (e) {
      print("Erro ao registrar utilizador: $e");
      return null;
    }
  }

  // 🔹 REGISTAR ASSOCIAÇÃO
  Future<User?> registerAssociacao(String email, String password, Map<String, dynamic> associacaoData) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection("associacao").doc(user.uid).set(associacaoData);
      }

      return user;
    } catch (e) {
      print("Erro ao registrar associação: $e");
      return null;
    }
  }


  // LOGIN
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // PEGAR Utilizador
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //DADOS DO Utilizador
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }
}
