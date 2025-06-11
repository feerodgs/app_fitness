import 'package:flutter/material.dart';

class HomeUsuario extends StatelessWidget {
  const HomeUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Usuário'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Bem-vindo, usuário!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
