import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'pin_setup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuir espacio entre los elementos
          crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontalmente
          children: [
            // Logo alineado a la derecha, tipo encabezado
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 55.0), // Mover más arriba
                child: Image.asset('assets/images/Frame.png', width: 90),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centrado de los demás elementos
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título y subtítulo centrados
                Text(
                  'Bienvenida a',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF440E31),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'QUOKA.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF440E31),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30), // Espacio entre el título y la imagen
                Image.asset(
                  'assets/images/llave.png',
                  width: MediaQuery.of(context).size.width * 0.55, // Centrado de la imagen
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20), // Espacio ajustado entre la imagen y el texto
                Text(
                  'Por favor, ingresa un PIN de seguridad.',
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Botón "Continuar" alineado al pie de página
            Align(
              alignment: Alignment.bottomRight, // Alineación al centro del pie de página
              child: Padding(
                padding: const EdgeInsets.only(bottom: 55.0), // Más espacio abajo
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Duration(milliseconds: 500),
                        child: PinEntryScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA31E67),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
