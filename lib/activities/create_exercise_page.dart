import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Página para criação de um novo exercício
class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({Key? key}) : super(key: key);

  @override
  State<CreateExercisePage> createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  final _photoController = TextEditingController();
  final _url1Controller = TextEditingController();
  final _url2Controller = TextEditingController();
  bool _situacao = true; // true=1 ativo, false=0 inativo
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Exercício'),
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Código',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _photoController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'URL da Foto',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _url1Controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'URL Adicional 1',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _url2Controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'URL Adicional 2',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('muscle_groups')
                    .where('inativo', isEqualTo: false)
                    .orderBy('name')
                    .snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) return const SizedBox();
                  final docs = snap.data!.docs;
                  return DropdownButtonFormField<String>(
                    value: _selectedGroup,
                    decoration: InputDecoration(
                      labelText: 'Grupo Muscular',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    items: docs.map((d) {
                      final name = d['name'] as String;
                      return DropdownMenuItem(
                        value: name,
                        child: Text(
                          name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedGroup = v),
                    validator: (v) => v == null ? 'Selecione um grupo' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Ativo?', style: TextStyle(color: Colors.white70)),
                  Switch(
                    activeColor: Colors.deepOrangeAccent,
                    value: _situacao,
                    onChanged: (v) => setState(() => _situacao = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  await FirebaseFirestore.instance.collection('exercises').add({
                    'codigo': _codeController.text.trim(),
                    'descricao': _descController.text.trim(),
                    'foto': _photoController.text.trim(),
                    'url1': _url1Controller.text.trim(),
                    'url2': _url2Controller.text.trim(),
                    'situacao': _situacao ? 1 : 0,
                    'muscleGroup': _selectedGroup,
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
