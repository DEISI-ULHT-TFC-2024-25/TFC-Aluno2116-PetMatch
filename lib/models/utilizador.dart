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
    String distrito;
    String localidade;
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
        required this.distrito,
        required this.localidade,
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
            distrito: map['distrito'] ?? '',
            localidade: map['localidade'] ?? '',
            zipCode: map['zipCode'] ?? '',
            password: map['password'] ?? '',
            associacoesEmQueEstaEnvolvido: map['associacoesEmQueEstaEnvolvido'] != null
                ? List<Associacao>.from(map['associacoesEmQueEstaEnvolvido']
                .map((x) => Associacao.fromMap(x['uid'] ?? '', x as Map<String, dynamic>)))
                : [],
            osSeusAnimais: List<String>.from(map['osSeusAnimais'] ?? []),
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
            'distrito': distrito,
            'localidade': localidade,
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
        final futures = animalUids.map((uid) async {
            final doc = await FirebaseFirestore.instance.collection('animal').doc(uid).get();
            final data = doc.data();
            if (doc.exists && data is Map<String, dynamic>) {
                return Animal.fromMap(data);
            } else {
                print("Erro: Documento $uid inválido ou tipo errado.");
            }
            return null;
        });

        final animais = await Future.wait(futures);
        return animais.whereType<Animal>().toList();
    }



}
