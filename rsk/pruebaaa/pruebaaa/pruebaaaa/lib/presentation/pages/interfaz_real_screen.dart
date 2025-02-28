import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pruebaaaa/presentation/pages/evidencias_screen.dart';
import 'package:pruebaaaa/presentation/pages/violentometro_screen.dart';
import 'package:pruebaaaa/presentation/pages/recursos_screen.dart';
import 'package:pruebaaaa/presentation/pages/ConfiguracionesScreen.dart';

class InterfazRealScreen extends StatefulWidget {
  const InterfazRealScreen({super.key});

  @override
  _InterfazRealScreenState createState() => _InterfazRealScreenState();
}

class _InterfazRealScreenState extends State<InterfazRealScreen> {
  int _currentIndex = 0;

  // Instancia para el almacenamiento seguro
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final List<Widget> _screens = [
    EvidenciasScreen(),
    ViolentometroScreen(),
    RecursosScreen(),
    ConfiguracionesScreen(),
  ];

  final List<String> _titles = [
    "Evidencias",
    "Violentómetro",
    "Recursos de Ayuda",
    "Configuraciones",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.purple,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.purple[50],
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Evidencias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: "Violentómetro",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: "Recursos"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configuraciones",
          ),
        ],
      ),
    );
  }
}
