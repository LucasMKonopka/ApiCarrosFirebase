import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para o logout
import 'package:trabalho4/services/carro_service.dart';
import 'package:trabalho4/view/carro_page.dart';
import 'package:trabalho4/view/carro_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarroService _carroService = CarroService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getCarros() {
    final userId = _auth.currentUser?.uid;

    // Consulta filtrando pelo userId
    return _firestore
        .collection('carros')
        .where('userId', isEqualTo: userId) // Filtra pelos carros do usuário
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros'),
        actions: [
          // Botão de Logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Botão de Adicionar Carro
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navegar para a página de adicionar carro (sem docId para criar um novo carro)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarroPage(carroId: ''),
                  ),
                );
              },
              child: Text('Adicionar Carro'),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _carroService
                  .readCarros(FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhum carro encontrado.'));
                }

                final carros = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: carros.length,
                  itemBuilder: (context, index) {
                    final carro = carros[index];
                    final docId = carro.id;
                    final marca = carro['marca'];
                    final modelo = carro['modelo'];

                    return ListTile(
                      title: Text('$marca - $modelo'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CarroPage(carroId: docId),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteCarro(docId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }

  Future<void> _deleteCarro(String docId) async {
    try {
      await _carroService.deleteCarro(docId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Carro excluído com sucesso!'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print('Erro ao excluir o carro: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Falha ao excluir o carro.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
