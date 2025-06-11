import 'package:flutter/material.dart';

class HomeAdm extends StatelessWidget {
  const HomeAdm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'Bem-vindo, administrador!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
