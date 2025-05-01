
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

class Pedido {
  final String id;
  final String funcionalidade; // Ex: "Apadrinhar", "TornarSocio", etc.
  final String utilizadorUid;
  final String associacaoId;
  final bool confirmouTodosOsRequisitos;
  final String mensagemAdicional;
  String estado;
  final Map<String, dynamic> dadosPrenchidos;

  Pedido({
    required this.id,
    required this.utilizadorUid,
    required this.funcionalidade,
    required this.associacaoId,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
    required this.estado,
    required this.dadosPrenchidos,
  });

  factory Pedido.fromMap(Map<String, dynamic> map, String documentId) {
    return Pedido(
      id: documentId,
      funcionalidade: map['oQuePretendeFazer'] ?? '',
      utilizadorUid: map['Uidutilizador'] ?? '',
      associacaoId: map['associacao'] ?? '',
      confirmouTodosOsRequisitos: map['confirmouTodosOsRequisitos'] ?? false,
      mensagemAdicional: map['mensagemAdicional'] ?? '',
      estado: map['estado'] ?? '',
      dadosPrenchidos: Map<String, dynamic>.from(map['dadosPreenchidos'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'oQuePretendeFazer': funcionalidade,
      'Uidutilizador': utilizadorUid,
      'associacao': associacaoId,
      'confirmouTodosOsRequisitos': confirmouTodosOsRequisitos,
      'mensagemAdicional': mensagemAdicional,
      'estado': estado,
      'dadosPreenchidos': dadosPrenchidos,
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
