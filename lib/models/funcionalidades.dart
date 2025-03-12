import 'package:cloud_firestore/cloud_firestore.dart';

enum Funcionalidades {
  passeiosDosCandeos,
  apradinhamento,
  socios,
  partilhaEventos,
  voluntariado,
  familiaAcolhimentoTemporario
}

class Funcionalidade {
  String id;
  Funcionalidades tipo;

  Funcionalidade({
    required this.id,
    required this.tipo,
  });

  factory Funcionalidade.fromMap(Map<String, dynamic> data, String id) {
    return Funcionalidade(
      id: id,
      tipo: Funcionalidades.values.firstWhere(
            (e) => e.toString() == data['tipo'],
        orElse: () => Funcionalidades.passeiosDosCandeos,
      ),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo.toString(),
    };
  }

  static Future<void> addFuncionalidade(String associacaoId, Funcionalidade funcionalidade) async {
    await FirebaseFirestore.instance
        .collection('associacoes')
        .doc(associacaoId)
        .collection('funcionalidades')
        .add(funcionalidade.toMap());
  }


  static Future<void> updateFuncionalidade(String associacaoId, Funcionalidade funcionalidade) async {
    await FirebaseFirestore.instance
        .collection('associacoes')
        .doc(associacaoId)
        .collection('funcionalidades')
        .doc(funcionalidade.id)
        .update(funcionalidade.toMap());
  }


  static Future<void> deleteFuncionalidade(String associacaoId, String funcionalidadeId) async {
    await FirebaseFirestore.instance
        .collection('associacoes')
        .doc(associacaoId)
        .collection('funcionalidades')
        .doc(funcionalidadeId)
        .delete();
  }


  static Stream<List<Funcionalidade>> getFuncionalidades(String associacaoId) {
    return FirebaseFirestore.instance
        .collection('associacoes')
        .doc(associacaoId)
        .collection('funcionalidades')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Funcionalidade.fromMap(doc.data(), doc.id))
        .toList());
  }
}
