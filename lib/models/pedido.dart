import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

class Pedido {
  final String id;
  final String utilizadorId;
  final String funcionalidade; // Ex: "Apadrinhar", "TornarSocio", etc.
  final String animalId;
  final String associacaoId;
  final bool confirmouTodosOsRequisitos;
  final String mensagemAdicional;
  String estado;
  final Map<String, dynamic> dadosPreenchidos;

  Pedido({
    required this.id,
    required this.utilizadorId,
    required this.funcionalidade,
    required this.animalId,
    required this.associacaoId,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
    required this.estado,
    required this.dadosPreenchidos,
  });


  factory Pedido.fromMap(Map<String, dynamic> map, String documentId) {
    return Pedido(
      id: documentId,
      utilizadorId: map['utilizadorQueRealizaOpedido'] ?? '',
      funcionalidade: map['oQuePretendeFazer'] ?? '',
      animalId: map['animalRequesitado'] ?? '',
      associacaoId: map['associacao'] ?? '',
      confirmouTodosOsRequisitos: map['confirmouTodosOsRequisitos'] ?? false,
      mensagemAdicional: map['mensagemAdicional'] ?? '',
      estado: map['estado'] ?? '',
      dadosPreenchidos: Map<String, dynamic>.from(map['dadosPreenchidos'] ?? {}),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'utilizadorQueRealizaOpedido': utilizadorId,
      'oQuePretendeFazer': funcionalidade,
      'animalRequesitado': animalId,
      'associacao': associacaoId,
      'confirmouTodosOsRequisitos': confirmouTodosOsRequisitos,
      'mensagemAdicional': mensagemAdicional,
      'estado': estado,
      'dadosPreenchidos': dadosPreenchidos,
    };
  }


  Future<void> atualizarEstadoNoFirestore(String novoEstado) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection("pedidosENotificacoes").doc(id).update({
      'estado': novoEstado,
    });

    estado = novoEstado; // Atualiza localmente também
  }

}
