import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> recarregarAssociacao() async {
    if (_association != null) {
      final doc = await FirebaseFirestore.instance
          .collection('associacao')
          .doc(_association!.uid)
          .get();

      _association = Associacao.fromFirestore(doc);
      notifyListeners();
    }
  }


}
