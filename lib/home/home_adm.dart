import 'package:fitness_app/activities/create_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // para formatar datas
import 'package:fitness_app/auth/login_page.dart'; // ajuste o caminho conforme o seu projeto

/// Tela principal para administradores (ADM)
class HomeAdm extends StatefulWidget {
  const HomeAdm({Key? key}) : super(key: key);

  @override
  State<HomeAdm> createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = <Widget>[
    _DashboardTab(),
    _ExercisesTab(),
    _ReportsTab(),
    _UsersTab(),
    _SettingsTab(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Painel Administrativo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Usuários'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Visão Geral',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ExercisesTab extends StatefulWidget {
  const _ExercisesTab();

  @override
  State<_ExercisesTab> createState() => __ExercisesTabState();
}

class __ExercisesTabState extends State<_ExercisesTab> {
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grupos musculares ativos
        SizedBox(
          height: 48,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('muscle_groups')
                .where('inativo', isEqualTo: false)
                .orderBy('name')
                .snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const SizedBox();
              final docs = snap.data!.docs;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final name = docs[i]['name'] as String;
                  return ChoiceChip(
                    label: Text(name),
                    selected: _selectedGroup == name,
                    onSelected: (_) => setState(() => _selectedGroup = name),
                    selectedColor: Colors.deepOrangeAccent,
                    backgroundColor: Colors.grey[800],
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Gerenciar Exercícios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Exercício'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateExercisePage(),
                    ),
                  ),
                ),
                // TODO: listar exercícios dinamicamente filtrados por _selectedGroup
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Relatórios de Treinos',
        style: TextStyle(color: Colors.white70, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro: ${snapshot.error}',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: DataTable(
            headingTextStyle: TextStyle(
              color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: TextStyle(color: Colors.white70),
            columns: const [
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('E-mail')),
              DataColumn(label: Text('Cadastro')),
              DataColumn(label: Text('Validade')),
            ],
            rows: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final nome = data['nome'] ?? '';
              final email = data['email'] ?? '';
              final dtCad = (data['dataCadastro'] as Timestamp).toDate();
              final dtVal = (data['dataValidade'] as Timestamp).toDate();
              return DataRow(
                cells: [
                  DataCell(Text(nome)),
                  DataCell(Text(email)),
                  DataCell(Text(DateFormat('dd/MM/yyyy').format(dtCad))),
                  DataCell(Text(DateFormat('dd/MM/yyyy').format(dtVal))),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.person, color: Colors.white70),
          title: const Text('Perfil', style: TextStyle(color: Colors.white)),
          onTap: () {
            // TODO: navegar ao perfil do ADM
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.white70),
          title: const Text('Sair', style: TextStyle(color: Colors.white)),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
