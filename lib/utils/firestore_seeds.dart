// lib/utils/firestore_seeds.dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedMuscleGroups() async {
  final firestore = FirebaseFirestore.instance;
  final groups = [
    'ABDÔMEN',
    'ANTEBRAÇO',
    'BÍCEPS',
    'COSTAS',
    'COXA',
    'GMED',
    'GMAX',
    'OMBRO',
    'PANTURILHA',
    'PEITO',
    'POSTERIOR DE COXA',
    'TRAPÉZIO',
    'TRÍCEPS',
  ];

  for (var name in groups) {
    await firestore.collection('muscle_groups').doc(name).set({
      'name': name,
      'inativo': false, // ← novo campo
    });
  }

  print('Muscle groups seeded with inativo flag!');
}
