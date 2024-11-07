import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animais.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/associacao.dart';

class Homescreens  {
  // Exemplo de dados do utilizador e associações
  final Utilizador user = new Utilizador(
    nif: 1234567,
    fullName: "blabla",
    cellphone: 999999999,
    isAdult: true,
    gender: 1,
    email: "asdfghjkl",
    address: "asdfghjkloiuytr",
    zone: "lalaland",
    zipCode: "123456-123",
    password: "123abc",

    associacoesEmQueEstaEnvolvido: [
      Associacao(name: "Associação A", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
      Associacao(name: "Associação B", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
      Associacao(name: "Associação C", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
      Associacao(name: "Associação D", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),

    ],
  );

  // Lista completa de associações para sugestões (em uma aplicação real, isso viria de uma API)
  final List<Associacao> todasAssociacoes = [
    Associacao(name: "Associação E", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação F", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação G", local: "Portimão", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação H", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação I", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação J", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação K", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação L", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
  ];

}

