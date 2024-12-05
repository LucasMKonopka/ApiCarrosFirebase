import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho4/components/my_button.dart';
import 'package:trabalho4/components/my_textfield.dart';
import 'package:trabalho4/view/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text
      );
      Navigator.pop(context);
    }on FirebaseAuthException catch(e) {
      print(e.code);
      if(e.code == 'invalid-credential') {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text('Usuário ou senha Incorretas'));
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget> [
                const SizedBox(height: 50.0),
                const Icon(Icons.car_rental, size: 100.0),
                const SizedBox(height: 50.0),
                Text(
                  'Seja Bem Vindo(a)',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 25.0
                  ),
                ),
                const SizedBox(height: 100.0),
                MyTextField(controller: userNameController, hintText: "E-mail", obscureText: false),
                const SizedBox(height: 15.0),
                MyTextField(controller: passwordController, hintText: "Senha", obscureText: true),
                const SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget> [
                      Text("Esqueceu sua Senha?", style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                MyButton(onTap: signUserIn, text: "Logar"),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    const Text("Não tem uma conta?", style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:(context) => const RegisterPage(),
                          )
                        );
                      },
                      child: const Text("Crie sua conta aqui!", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}