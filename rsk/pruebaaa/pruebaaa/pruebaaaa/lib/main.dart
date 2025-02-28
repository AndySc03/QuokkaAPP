import 'package:flutter/material.dart';
import 'package:pruebaaaa/presentation/pages/inicio_screen.dart'; // Asegúrate de tener esta pantalla
import 'package:pruebaaaa/presentation/pages/ForgotPasswordPage.dart'; // Asegúrate de tener esta pantalla
import 'package:pruebaaaa/presentation/pages/registro_screen.dart'; // Asegúrate de tener esta pantalla
import 'package:pruebaaaa/presentation/pages/mascota_screen.dart'; // Asegúrate de tener esta pantalla
import 'package:pruebaaaa/presentation/pages/violentometro_screen.dart'; // Asegúrate de tener esta pantalla
import 'package:pruebaaaa/presentation/pages/recursos_screen.dart';

import 'presentation/pages/ConfiguracionesScreen.dart';
import 'presentation/pages/interfaz_real_screen.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/mascota_tutorial_screen.dart';
import 'presentation/pages/pin_setup_screen.dart';
import 'presentation/pages/screenwelcome.dart'; // Asegúrate de tener esta pantalla

void main() {
  runApp(QuokkaApp());
}

class QuokkaApp extends StatelessWidget {
  const QuokkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quokka App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => InicioScreen(), // Pantalla de inicio de la app
        '/login': (context) => LoginScreen(),
        '/recuperar_password': (context) => ForgotPasswordPage(),
        '/registro': (context) => RegisterScreen(),
        '/mascota': (context) => GamePage(),
        '/violentometro': (context) => ViolentometroScreen(),
        '/recursos': (context) => RecursosScreen(),
        '/configurar_nip': (context) => PinEntryScreen(),
        '/InterfazRealScreen': (context)=> InterfazRealScreen(),
        '/ConfiguracionesScreen':(context)=> ConfiguracionesScreen(),
        '/WelcomeScreen': (context) => WelcomeScreen(),
        '/GamePage': (context) => GamePage(),
        '/MascotaTutorialScreen': (context) => MascotaTutorialScreen(),
        '/PinEntryScreen': (context) => PinEntryScreen()
      },
    );
  }
}
