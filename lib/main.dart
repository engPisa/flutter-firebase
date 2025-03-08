import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseForm(),
    );
  }
}

class FirebaseForm extends StatefulWidget {
  @override
  _FirebaseFormState createState() => _FirebaseFormState();
}

class _FirebaseFormState extends State<FirebaseForm>{

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  void _enviarValor() async{
    String nome = _nomeController.text;
    String quantidade = _quantidadeController.text;
    String valor = _valorController.text;

    if (nome.isEmpty || quantidade.isEmpty || valor.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
    }

    try {
      await _databaseRef.child('produtos').push().set({
        'nome': nome,
        'quantidade': quantidade,
        'valor': valor,
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Produto salvo com sucesso!")),
      );

      _nomeController.clear();
      _quantidadeController.clear();
      _valorController.clear();

    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salvando produtos no firebase")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
              ),
            ),
            TextFormField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                  labelText: "Quantidade"
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(
                  labelText: "Valor"
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarValor,
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}

