import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';

class Pedido {
  Utilizador utilizadorQueRealizaOpedido;
  Funcionalidades oQuePretendeFazer;
  Animal animalRequesitado;
  Associacao associacao;
  bool confirmouTodosOsRequisitos;
  String mensagemAdicional;

  // Construtor da classe
  Pedido({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
  });

  // fromMap
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      utilizadorQueRealizaOpedido: Utilizador.fromMap(
        map['utilizadorQueRealizaOpedido'] as Map<String, dynamic>,
      ),
      oQuePretendeFazer: (map['oQuePretendeFazer'] ?? ''),
      animalRequesitado: Animal.fromMap(
        map['animalRequesitado'] as Map<String, dynamic>,
      ),
      associacao: Associacao.fromMap(
        map['associacao'] as Map<String, dynamic>,
      ),
      confirmouTodosOsRequisitos: map['confirmouTodosOsRequisitos'] ?? false,
      mensagemAdicional: map['mensagemAdicional'] ?? '',
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'utilizadorQueRealizaOpedido': utilizadorQueRealizaOpedido.toMap(),
      'oQuePretendeFazer': (oQuePretendeFazer),
      'animalRequesitado': animalRequesitado.toMap(),
      'associacao': associacao.toMap(),
      'confirmouTodosOsRequisitos': confirmouTodosOsRequisitos,
      'mensagemAdicional': mensagemAdicional,
    };
  }
}