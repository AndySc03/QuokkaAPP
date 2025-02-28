import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pruebaaaa/presentation/pages/interfaz_real_screen.dart';
import 'package:pruebaaaa/presentation/pages/evidencias_screen.dart';
import 'package:pruebaaaa/presentation/pages/violentometro_screen.dart';
import 'package:pruebaaaa/presentation/pages/recursos_screen.dart';

class RealTutorialScreen extends StatefulWidget {
  const RealTutorialScreen({super.key});

  @override
  _RealTutorialScreenState createState() => _RealTutorialScreenState();
}

class _RealTutorialScreenState extends State<RealTutorialScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  Future<void> _marcarTutorialComoCompletado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("tutorialRealCompletado", true);
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
        MaterialPageRoute(builder: (context) => InterfazRealScreen()),
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
                  screen: EvidenciasScreen(),
                  title: "Recolección de Evidencias",
                  description: "Aquí puedes guardar imágenes, audios o videos de manera segura.",
                ),
                _buildTutorialPage(
                  screen: ViolentometroScreen(),
                  title: "Violentómetro",
                  description: "Evalúa tu nivel de riesgo con base en señales de violencia.",
                ),
                _buildTutorialPage(
                  screen: RecursosScreen(),
                  title: "Recursos y Ayuda",
                  description: "Consulta números de emergencia y centros de apoyo cercanos.",
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

  Widget _buildTutorialPage({required Widget screen, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: screen), // Muestra la pantalla real dentro del tutorial
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[800]),
              ),
              SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
