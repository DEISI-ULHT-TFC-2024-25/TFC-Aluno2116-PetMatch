import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authenticationservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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


  Future<User?> registerAssociacao(String email, String password, Map<String, dynamic> associacaoData) async {
    try {
      print("Iniciando criação de conta para: $email");

      // Debug do conteúdo enviado para o Firestore
      print(" Dados enviados para Firestore:");
      associacaoData.forEach((key, value) {
        print("  $key: $value (${value.runtimeType})");
      });

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        print("Utilizador criado: ${user.uid}");

        await _firestore.collection("associacao").doc(user.uid).set(associacaoData);
        print("Dados guardados no Firestore com sucesso.");
      }

      return user;
    } catch (e) {
      print("❌ Erro ao registrar associação: $e");
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


  User? getCurrentUser() {
    return _auth.currentUser;
  }


  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  Future<void> atualizarPassword(String novaPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(novaPassword);
    }
  }

  Future<void> atualizarEmail(String novoEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(novoEmail);
    }
  }

}
