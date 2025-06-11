import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String nome;
  final String email;
  final String tipo; // usuario adm
  final DateTime dataCadastro;
  final DateTime? dataValidade; // só para usuários

  AppUser({
    required this.uid,
    required this.nome,
    required this.email,
    required this.tipo,
    required this.dataCadastro,
    this.dataValidade,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      nome: data['nome'],
      email: data['email'],
      tipo: data['tipo'],
      dataCadastro: (data['dataCadastro'] as Timestamp).toDate(),
      dataValidade: data['dataValidade'] != null
          ? (data['dataValidade'] as Timestamp).toDate()
          : null,
    );
  }
}
