
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, Timestamp;

class Pedido {
  final String id;
  final String funcionalidade; // Ex: "Apadrinhar", "TornarSocio", etc.
  final String utilizadorUid;
  final String uidAssociacao;
  final DateTime dataCriacao;
  final String? nomeAssociacao;
  final bool confirmouTodosOsRequisitos;
  final String mensagemAdicional;
  String estado;
  final Map<String, dynamic> dadosPrenchidos;

  Pedido({
    required this.id,
    required this.utilizadorUid,
    required this.funcionalidade,
    required this.uidAssociacao,
    required this.dataCriacao,
    this.nomeAssociacao,
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
      uidAssociacao: map['uidAssociacao'] ?? '',
      dataCriacao: (map['dataCriacao'] as Timestamp).toDate(),
      nomeAssociacao: map['nomeAssociacao']?? '',
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
      'uidAssociacao': uidAssociacao,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'nomeAssociacao': nomeAssociacao,
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
