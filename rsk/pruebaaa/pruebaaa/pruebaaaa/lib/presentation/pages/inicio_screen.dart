import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pruebaaaa/presentation/pages/login_screen.dart';
import 'package:pruebaaaa/presentation/pages/mascota_screen.dart'; // Asegúrate de que GameScreen esté importado

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Instancia de FlutterSecureStorage

  @override
  void initState() {
    super.initState();
    _verificarSesionGuardada();
  }

  // Verificar si hay sesión guardada
  void _verificarSesionGuardada() async {
    String? usuarioId = await _storage.read(key: 'usuarioId');
    String? token = await _storage.read(key: 'token');

    await Future.delayed(Duration(seconds: 3)); // Esperar 3 segundos

    if (usuarioId != null && token != null) {
      // Si la sesión está guardada, redirigir al GameScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GamePage()), // Redirigir a la pantalla de juego
      );
    } else {
      // Si no hay sesión guardada, redirigir al LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 252, 253), // Fondo morado para la identidad de Quokka
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_quoka.png', // Asegúrate de tener este logo en tu carpeta assets
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              "Quokka",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Seguridad en tus manos",
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(179, 143, 128, 128),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
