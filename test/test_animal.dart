import 'package:tinder_para_caes/models/animal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Animal', () {
    test('fromMap creates a valid Animal instance', () {
      final map = {
        'chip': 12345,
        'fullName': 'Buddy',
        'age': 5,
        'sterilized': true,
        'gender': 'Male',
        'legalOwner': 'John Doe',
        'allergies': 'None',
        'size': 'Medium',
        'behavior': 'Friendly',
        'breed': 'Golden Retriever',
        'species': 'Dog',
        'numeroDePasseiosDados': 10,
        'hasGodFather': true,
        'hasFat': false,
        'imagens': ['image1.jpg', 'image2.jpg'],
      };

      final animal = Animal.fromMap(map);

      expect(animal.chip, 12345);
      expect(animal.fullName, 'Buddy');
      expect(animal.age, 5);
      expect(animal.sterilized, true);
      expect(animal.gender, 'Male');
      expect(animal.legalOwner, 'John Doe');
      expect(animal.allergies, 'None');
      expect(animal.size, 'Medium');
      expect(animal.behavior, 'Friendly');
      expect(animal.breed, 'Golden Retriever');
      expect(animal.species, 'Dog');
      expect(animal.numeroDePasseiosDados, 10);
      expect(animal.hasGodFather, true);
      expect(animal.hasFat, false);
      expect(animal.imagens, ['image1.jpg', 'image2.jpg']);
    });

    test('fromMap handles missing or null fields', () {
      final map = {
        'chip': 12345,
        'fullName': 'Bella',
        // Age, sterilized, gender, etc. are missing
        'imagens': [],
      };

      final animal = Animal.fromMap(map);

      expect(animal.chip, 12345);
      expect(animal.fullName, 'Bella');
      expect(animal.age, 0); // Default value when not provided
      expect(animal.sterilized, false); // Default value
      expect(animal.gender, ''); // Default value
      expect(animal.legalOwner, ''); // Default value
      expect(animal.allergies, ''); // Default value
      expect(animal.size, ''); // Default value
      expect(animal.behavior, ''); // Default value
      expect(animal.breed, ''); // Default value
      expect(animal.species, ''); // Default value
      expect(animal.numeroDePasseiosDados, 0); // Default value
      expect(animal.hasGodFather, false); // Default value
      expect(animal.hasFat, false); // Default value
      expect(animal.imagens, []); // Default value
    });

    test('fromMap handles empty map', () {
      final Map<String, dynamic> map = {};

      final animal = Animal.fromMap(map);

      expect(animal.chip, 0); // Default value
      expect(animal.fullName, ''); // Default value
      expect(animal.age, 0); // Default value
      expect(animal.sterilized, false); // Default value
      expect(animal.gender, ''); // Default value
      expect(animal.legalOwner, ''); // Default value
      expect(animal.allergies, ''); // Default value
      expect(animal.size, ''); // Default value
      expect(animal.behavior, ''); // Default value
      expect(animal.breed, ''); // Default value
      expect(animal.species, ''); // Default value
      expect(animal.numeroDePasseiosDados, 0); // Default value
      expect(animal.hasGodFather, false); // Default value
      expect(animal.hasFat, false); // Default value
      expect(animal.imagens, []); // Default value
    });
  });
}

