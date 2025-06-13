import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../home/home_usuario.dart';
import '../home/home_adm.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool lembrar = false;
  bool _showPassword = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> login() async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );
      final doc = await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .get();
      if (!doc.exists) throw Exception("Usuário não encontrado no Firestore.");
      final appUser = AppUser.fromMap(doc.id, doc.data()!);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              appUser.tipo == "adm" ? const HomeAdm() : const HomeUsuario(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: \$e')));
    }
  }

  void esqueciSenha() {
    showDialog(context: context, builder: (_) => const EsqueciSenhaDialog());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/strong-man.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: size.width > 400 ? 400 : size.width * 0.9,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        'assets/gym_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Acesse sua conta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Faça login para aproveitar todos os recursos.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Email com label flutuante
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: const TextStyle(color: Colors.white70),
                        floatingLabelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[800],
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white70,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Senha com toggle e label flutuante
                    TextField(
                      controller: senhaController,
                      obscureText: !_showPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(color: Colors.white70),
                        floatingLabelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[800],
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(() {
                            _showPassword = !_showPassword;
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: esqueciSenha,
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Ainda não tem uma conta? ',
                          style: TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: 'Cadastrar',
                              style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EsqueciSenhaDialog extends StatefulWidget {
  const EsqueciSenhaDialog({super.key});

  @override
  State<EsqueciSenhaDialog> createState() => _EsqueciSenhaDialogState();
}

class _EsqueciSenhaDialogState extends State<EsqueciSenhaDialog> {
  final emailController = TextEditingController();
  bool enviado = false;

  Future<void> enviarReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      setState(() => enviado = true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: \$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Redefinir senha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),
              if (!enviado)
                TextField(
                  controller: emailController,
                  maxLength: 150,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Seu e-mail', // rótulo flutuante
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                    ), // cor do label
                    floatingLabelStyle: const TextStyle(
                      color: Colors.grey,
                    ), // cor ao flutuar
                    filled: true,
                    fillColor: Colors.grey[800],
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Verifique seu e-mail para instruções.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!enviado)
                    ElevatedButton(
                      onPressed: enviarReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
