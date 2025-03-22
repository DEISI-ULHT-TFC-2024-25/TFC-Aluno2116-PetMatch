import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'associacao.dart';

class Utilizador {
    String uid;
    int nif;
    String fullName;
    String cellphone;
    bool isAdult;
    String gender;
    String email;
    String address;
    String local;
    String zipCode;
    String password;

    List<Associacao> associacoesEmQueEstaEnvolvido;
    List<String> osSeusAnimais;
    bool associacao;

    Utilizador({
        required this.uid,
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


    factory Utilizador.fromMap(String documentId, Map<String, dynamic> map) {
        return Utilizador(
            uid: documentId,
            nif: map['nif'] is int ? map['nif'] : int.tryParse(map['nif'].toString()) ?? 0,
            fullName: map['fullName'] ?? '',
            cellphone: map['cellphone']  ?? '',
            isAdult: map['isAdult'] ?? false,
            gender: map['gender']  ?? ' ',
            email: map['email'] ?? '',
            address: map['address'] ?? '',
            local: map['local'] ?? '',
            zipCode: map['zipCode'] ?? '',
            password: map['password'] ?? '',
            associacoesEmQueEstaEnvolvido: map['associacoesEmQueEstaEnvolvido'] != null
                ? List<Associacao>.from(map['associacoesEmQueEstaEnvolvido']
                .map((x) => Associacao.fromMap(x['uid'] ?? '', x as Map<String, dynamic>)))
                : [],
            osSeusAnimais: List<String>.from(map['animais'] ?? []),
            associacao: map['associacao'] ?? false,
        );
    }


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
            'osSeusAnimais': osSeusAnimais,
            'associacao': associacao,
        };
    }

    factory Utilizador.fromFirestore(DocumentSnapshot doc) {
        return Utilizador.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }


    Future<List<Animal>> fetchAnimals(List<String> animalUids) async {
        List<Animal> animals = [];
        for (String uid in animalUids) {
            DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('animal').doc(uid).get();
            if (doc.exists) {
                final data = doc.data();

                if (data is Map<String, dynamic>) {
                    animals.add(Animal.fromMap(data));
                } else {
                    print("⚠️ Erro: Documento $uid não contém um Map válido. Tipo: ${data.runtimeType}, Conteúdo: $data");
                }
            }
        }
        return animals;
    }


    static final Utilizador user = Utilizador(
        uid: "123456", //
        nif: 1234567,
        fullName: "Batata",
        cellphone: " ",
        isAdult: true,
        gender: "Masculino",
        email: "batata@ulusofona.pt",
        address: "Campo Grande 376",
        local: "Lisboa",
        zipCode: "123456-123",
        password: "123abc",
        associacoesEmQueEstaEnvolvido: [
            Associacao(
                uid:"jfkd",
                name: "Associação A",
                local: "Lisboa",
                nif: 0,
                sigla: '',
                generalEmail: '',
                secundaryEmail: '',
                mainCellphone: " ",
                address: '',
                secundaryCellphone: " ",
                showAddress: false,
                site: '',
                eventos: [],
                necessidades: [],
                funcionalidades: [],
                animais: [],
                pedidosRealizados: [],
            ),
        ],
        osSeusAnimais: [],
        associacao: false,
    );
}
