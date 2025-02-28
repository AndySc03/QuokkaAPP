import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfiguracionesScreen extends StatefulWidget {
  const ConfiguracionesScreen({super.key});

  @override
  _ConfiguracionesScreenState createState() => _ConfiguracionesScreenState();
}

class ButtonCombination {
  final String name;
  final List<String> buttons;

  ButtonCombination({required this.name, required this.buttons});
}

class _ConfiguracionesScreenState extends State<ConfiguracionesScreen> {
  // Instancia para el almacenamiento seguro
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Lista de combinaciones de botones para audio
  final List<ButtonCombination> _audioCombinations = [
    ButtonCombination(name: "Audio Combinación 1", buttons: ["Volumen Arriba", "Apagar"]),
    ButtonCombination(name: "Audio Combinación 2", buttons: ["Volumen Abajo", "Apagar"]),
  ];

  // Lista de combinaciones de botones para video
  final List<ButtonCombination> _videoCombinations = [
    ButtonCombination(name: "Video Combinación 1", buttons: ["Volumen Arriba", "Volumen Abajo"]),
    ButtonCombination(name: "Video Combinación 2", buttons: ["Volumen Abajo", "Apagar"]),
  ];

  // Variables para almacenar las combinaciones seleccionadas
  ButtonCombination? _selectedAudioCombination;
  ButtonCombination? _selectedVideoCombination;

  // Método para cerrar sesión y eliminar datos almacenados
  void _logout(BuildContext context) async {
    // Elimina todos los datos almacenados en FlutterSecureStorage
    await _storage.deleteAll();

    // Navega a la pantalla de login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuraciones"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección de combinaciones de audio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Combinaciones de Audio",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _audioCombinations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_audioCombinations[index].name),
                  trailing: Radio<ButtonCombination>(
                    value: _audioCombinations[index],
                    groupValue: _selectedAudioCombination,
                    onChanged: (ButtonCombination? value) {
                      setState(() {
                        _selectedAudioCombination = value;
                      });
                    },
                  ),
                );
              },
            ),

            // Sección de combinaciones de video
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Combinaciones de Video",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _videoCombinations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_videoCombinations[index].name),
                  trailing: Radio<ButtonCombination>(
                    value: _videoCombinations[index],
                    groupValue: _selectedVideoCombination,
                    onChanged: (ButtonCombination? value) {
                      setState(() {
                        _selectedVideoCombination = value;
                      });
                    },
                  ),
                );
              },
            ),

            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text("Cerrar sesión"),
            ),
          ],
        ),
      ),
    );
  }
}

