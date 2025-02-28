import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pruebaaaa/presentation/pages/mascota_screen.dart'; // Asegúrate de que GameScreen esté importado

class MascotaTutorialScreen extends StatefulWidget {
  const MascotaTutorialScreen({super.key});

  @override
  _MascotaTutorialScreenState createState() => _MascotaTutorialScreenState();
}

class _MascotaTutorialScreenState extends State<MascotaTutorialScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  Future<void> _marcarTutorialComoCompletado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("tutorialMascotaCompletado", true);
  }

  void _siguientePagina() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _marcarTutorialComoCompletado();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GamePage()), // Redirigir a GameScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildTutorialPage(
                  image: "assets/images/ajolote_1.png",
                  title: "¡Bienvenido a Quokka!",
                  description:
                      "Esta es tu mascota virtual. Cuídala, aliméntala y juega con ella como en un juego real.",
                ),
                _buildTutorialPage(
                  image: "assets/images/ajolote_2.png",
                  title: "Modo Secreto",
                  description:
                      "Pero hay algo más... si presionas el botón de menú, podrás acceder a la interfaz real de Quokka.",
                ),
                _buildTutorialPage(
                  image: "assets/images/icono_menu.png",
                  title: "Tu Seguridad Primero",
                  description:
                      "El menú te llevará a la parte segura de la app. Allí puedes recopilar evidencias y acceder a ayuda.",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _siguientePagina,
              child: Text(_currentPage < 2 ? "Siguiente" : "Finalizar"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage({required String image, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, width: 200),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[800]),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
