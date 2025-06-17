import 'package:cloud_firestore/cloud_firestore.dart';


class Funcionalidade {
  String id;
  String tipo;

  Funcionalidade({
    required this.id,
    required this.tipo,
  });

  @override
  String toString() {
    return tipo.toString();
  }


  factory Funcionalidade.fromMap(Map<String, dynamic> map, String id) {
    return Funcionalidade(
      id: id,
      tipo: map['tipo'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
    };
  }

  static Future<void> addFuncionalidade(String associacaoId, Funcionalidade funcionalidade) async {
    await FirebaseFirestore.instance
        .collection('associacoes')
        .doc(associacaoId)
        .collection('funcionalidades')
        .add(funcionalidade.toMap());
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
