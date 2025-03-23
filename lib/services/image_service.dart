import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Escolhe imagem da galeria
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print("Nenhuma imagem selecionada.");
      return null;
    }
  }

  /// Faz upload para o Firebase Storage e retorna o URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = basename(imageFile.path);
      final storageRef =
      FirebaseStorage.instance.ref().child('imagens/$fileName');

      await storageRef.putFile(imageFile);

      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Erro ao fazer upload: $e");
      return null;
    }
  }

  /// Guarda a URL da imagem no Firestore
  Future<void> saveImageUrlToFirestore(String url) async {
    await FirebaseFirestore.instance.collection('fotos').add({
      'imageUrl': url,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
