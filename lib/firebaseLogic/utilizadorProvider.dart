import 'package:flutter/foundation.dart';
import 'package:tinder_para_caes/models/utilizador.dart';

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
}
