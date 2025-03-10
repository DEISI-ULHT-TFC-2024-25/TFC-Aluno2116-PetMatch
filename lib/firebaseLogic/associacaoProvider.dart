import 'package:flutter/foundation.dart';
import 'package:tinder_para_caes/models/associacao.dart';

class AssociacaoProvider extends ChangeNotifier {
  Associacao? _association;

  Associacao? get association => _association;

  void setAssociation(Associacao newAssociation) {
    _association = newAssociation;
    notifyListeners();
  }

  void clearAssociation() {
    _association = null;
    notifyListeners();
  }
}
