import 'package:flutter/foundation.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilizadorProvider extends ChangeNotifier {
  Utilizador? _user;

  Utilizador? get user => _user;

  void setUser(Utilizador newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> recarregarUtilizador() async {
    if (_user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(_user!.uid)
          .get();

      _user = Utilizador.fromFirestore(doc);
      notifyListeners();
    }
  }

}
