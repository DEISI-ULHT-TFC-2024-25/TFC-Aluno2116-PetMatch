import 'package:tinder_para_caes/models/animal.dart' show Animal;
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';
import 'package:tinder_para_caes/models/utilizador.dart' show Utilizador;

class Pedido {
  String id;
  Utilizador utilizadorQueRealizaOpedido;
  Funcionalidade oQuePretendeFazer;
  Animal animalRequesitado;
  Associacao associacao;
  bool confirmouTodosOsRequisitos;
  String mensagemAdicional;
  String estado;
  List<String> dadosPrenchidos;

  Pedido({
    required this.id,
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
    required this.estado,
    required this.dadosPrenchidos,
  });

  factory Pedido.fromMap(Map<String, dynamic> map, String documentId) {
    return Pedido(
      id: documentId,
      utilizadorQueRealizaOpedido: Utilizador.fromMap(
        map['utilizadorQueRealizaOpedido']['uid'] ?? '',
        map['utilizadorQueRealizaOpedido'] as Map<String, dynamic>,
      ),
      oQuePretendeFazer: Funcionalidade.fromMap(
        map['oQuePretendeFazer'] as Map<String, dynamic>,
        map['oQuePretendeFazer']['id'] ?? '',
      ),
      animalRequesitado: Animal.fromMap(
        map['animalRequesitado'] as Map<String, dynamic>,
      ),
      associacao: Associacao.fromMap(
        map['associacao']['uid'] ?? '',
        map['associacao'] as Map<String, dynamic>,
      ),
      confirmouTodosOsRequisitos: map['confirmouTodosOsRequisitos'] ?? false,
      mensagemAdicional: map['mensagemAdicional'] ?? '',
      estado: map['estado'] ?? '',
      dadosPrenchidos: List<String>.from(map['dadosPrenchidos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'utilizadorQueRealizaOpedido': utilizadorQueRealizaOpedido.toMap(),
      'oQuePretendeFazer': oQuePretendeFazer.toMap(),
      'animalRequesitado': animalRequesitado.toMap(),
      'associacao': associacao.toMap(),
      'confirmouTodosOsRequisitos': confirmouTodosOsRequisitos,
      'mensagemAdicional': mensagemAdicional,
      'estado': estado,
      'dadosPrenchidos': dadosPrenchidos,
    };
  }
}
