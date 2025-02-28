import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'comprobar_nip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Mascotas',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late String usuarioId;
  String nombreMascota = "Cargando...";
  String colorMascota = "Cargando...";
  int energy = 100;
  late DateTime lastFedTime;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadMascota();
  }

  Future<void> loadMascota() async {
    usuarioId = await storage.read(key: 'usuarioId') ?? '';
    if (usuarioId.isEmpty) {
      usuarioId = 'usuario_${DateTime.now().millisecondsSinceEpoch}';
      await storage.write(key: 'usuarioId', value: usuarioId);
    }
    setState(() {
      nombreMascota = 'Quoky';
      colorMascota = 'rosa';
      energy = 100;
      lastFedTime = DateTime.now();
    });
  }

  void feedMascota() {
    setState(() {
      energy = 100;
      lastFedTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego de Energía'),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 50,
            child: Image.asset('assets/images/piedra.png', width: 200),
          ),
          Positioned(
            bottom: 120, // Ajusta esta posición para centrar la mascota sobre la piedra
            left: 90, // Ajusta según el tamaño de la piedra y la imagen
            child: Image.asset(
              'assets/images/ajolote_1.png',
              width: 150, // Ajusta el tamaño si es necesario
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreMascota,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Color: $colorMascota',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Energía: $energy',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Última alimentación: ${lastFedTime.toLocal()}',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: feedMascota,
                  icon: Icon(Icons.fastfood),
                  label: Text("Alimentar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 159, 189),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PinEntryScreen()),
                    );
                  },
                  icon: Icon(Icons.lock),
                  label: Text("Validar NIP"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 242, 168, 255),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
