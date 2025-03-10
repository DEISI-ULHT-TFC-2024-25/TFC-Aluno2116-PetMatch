enum Funcionalidades {
  passeiosDosCandeos,
  apradinhamento,
  socios,
  partilhaEventos,
  voluntariado,
  familiaAcolhimentoTemporario

}
extension FuncionalidadesExtension on Funcionalidades {
  /// Retorna apenas o nome (sem o prefixo da enum).
  String get name => toString().split('.').last;

  /// Retorna um rótulo descritivo para cada valor do enum.
  String get label {
    switch (this) {
      case Funcionalidades.passeiosDosCandeos:
        return 'Passeios dos Cãezinhos';
      case Funcionalidades.apradinhamento:
        return 'Apadrinhamento';
      case Funcionalidades.socios:
        return 'Socios';
      case Funcionalidades.partilhaEventos:
        return 'Partilha de eventos';
      case Funcionalidades.voluntariado:
        return 'Voluntariado';
      case Funcionalidades.familiaAcolhimentoTemporario:
        return 'Familia de acolhimento temporario';
    }
  }
}

