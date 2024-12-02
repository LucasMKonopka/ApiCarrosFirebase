import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import necessário para logout
import 'package:trabalho4/services/carro_service.dart';
import 'carro_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarroService _carroService = CarroService();
  final String userId = 'userIdDoUsuario'; // Substitua pelo ID real do usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Carros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarroPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _carroService.readCarros(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final carros = snapshot.data!.docs;

          if (carros.isEmpty) {
            return const Center(
              child: Text('Nenhum carro cadastrado.'),
            );
          }

          return ListView.builder(
            itemCount: carros.length,
            itemBuilder: (context, index) {
              final carroData = carros[index].data() as Map<String, dynamic>;
              final carroId = carros[index].id;

              return ListTile(
                title: Text('${carroData['marca']} ${carroData['modelo']}'),
                subtitle: Text(
                    '${carroData['ano']} - ${carroData['cor']} - ${carroData['categoria']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarroPage(),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _carroService.deleteCarro(carroId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
