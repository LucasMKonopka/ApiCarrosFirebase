import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Usuário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirmar Senha"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AuthService().userRegister(
                  context,
                  emailController,
                  passwordController,
                  confirmPasswordController,
                );
              },
              child: const Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
