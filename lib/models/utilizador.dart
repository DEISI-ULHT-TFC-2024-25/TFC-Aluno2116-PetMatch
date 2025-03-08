import 'package:tinder_para_caes/models/animal.dart';
import 'associacao.dart';

class Utilizador {
    int nif;
    String fullName;
    int cellphone;
    bool isAdult;
    int gender; // 0 - Feminino, 1 - Masculino, 2 - Outros
    String email;
    String address;
    String local;
    String zipCode;
    String password;

    List<Associacao> associacoesEmQueEstaEnvolvido;
    List<Animal> osSeusAnimais;
    bool associacao;

    Utilizador({
        required this.nif,
        required this.fullName,
        required this.cellphone,
        required this.isAdult,
        required this.gender,
        required this.email,
        required this.address,
        required this.local,
        required this.zipCode,
        required this.password,
        required this.associacoesEmQueEstaEnvolvido,
        required this.osSeusAnimais,
        required this.associacao,
    });

    /// Construtor para criar um objeto Utilizador a partir de um Map (do Firestore)
    factory Utilizador.fromMap(Map<String, dynamic> map) {
        return Utilizador(
            nif: map['nif'] is int ? map['nif'] : int.tryParse(map['nif'].toString()) ?? 0,
            fullName: map['fullName'] ?? '',
            cellphone: map['cellphone'] is int ? map['cellphone'] : int.tryParse(map['cellphone'].toString()) ?? 0,
            isAdult: map['isAdult'] ?? false,
            gender: map['gender'] is int ? map['gender'] : int.tryParse(map['gender'].toString()) ?? 0,
            email: map['email'] ?? '',
            address: map['address'] ?? '',
            local: map['local'] ?? '',
            zipCode: map['zipCode'] ?? '',
            password: map['password'] ?? '',
            associacoesEmQueEstaEnvolvido: map['associacoesEmQueEstaEnvolvido'] != null
                ? List<Associacao>.from(
                map['associacoesEmQueEstaEnvolvido'].map((x) => Associacao.fromMap(x)))
                : [],
            osSeusAnimais: map['osSeusAnimais'] != null
                ? List<Animal>.from(map['osSeusAnimais'].map((x) => Animal.fromMap(x)))
                : [],
            associacao: map['associacao'] ?? false,
        );
    }

    /// Converte o objeto Utilizador em um Map (útil para salvar no Firestore ou converter para JSON)
    Map<String, dynamic> toMap() {
        return {
            'nif': nif,
            'fullName': fullName,
            'cellphone': cellphone,
            'isAdult': isAdult,
            'gender': gender,
            'email': email,
            'address': address,
            'local': local,
            'zipCode': zipCode,
            'password': password,
            'associacoesEmQueEstaEnvolvido': associacoesEmQueEstaEnvolvido.map((a) => a.toMap()).toList(),
            'osSeusAnimais': osSeusAnimais.map((a) => a.toMap()).toList(),
            'associacao': associacao,
        };
    }

    // Exemplo de instância estática (útil para testes)
    static final Utilizador user = Utilizador(
        nif: 1234567,
        fullName: "Pedro Alves",
        cellphone: 999999999,
        isAdult: true,
        gender: 1,
        email: "pedro.alves@ulusofona.pt",
        address: "Campo Grande 376",
        local: "Lisboa",
        zipCode: "123456-123",
        password: "123abc",
        associacoesEmQueEstaEnvolvido: [
            Associacao(
                name: "Associação A",
                local: "Lisboa",
                nif: 0,
                sigla: '',
                generalEmail: '',
                secundaryEmail: '',
                mainCellphone: 0,
                address: '',
                secundaryCellphone: 0,
                showAddress: false,
                site: '',
                funcionalidades: [],
                animais: [],
                pedidosRealizados: [],
            ),
            // Adicione outras associações, se necessário
        ],
        osSeusAnimais: [],
        associacao: false,
    );
}
