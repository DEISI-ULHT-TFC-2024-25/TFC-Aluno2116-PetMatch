import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';

class Pedido {
  Utilizador utilizadorQueRealizaOpedido;
  String oQuePretendeFazer;
  Animal animalRequesitado;
  Associacao associacao;
  bool confirmouTodosOsRequisitos;

  // Construtor da classe
  Pedido({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,

  });
}
