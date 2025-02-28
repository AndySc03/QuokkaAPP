import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool showEyeIcon = false;
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Instancia de FlutterSecureStorage

  Future<void> loginUser(BuildContext context) async {
    // Verificar si los campos están vacíos antes de proceder
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackbar(
        context,
        "Error",
        "Por favor, ingresa tu correo y contraseña.",
      );
      return;
    }

    setState(() => isLoading = true);
    final url = Uri.parse('https://quoka.onrender.com/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': emailController.text,
          'contrasena': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackbar(context, "Éxito", "Inicio de sesión exitoso.");

        final user = jsonDecode(response.body);
        if (user['tieneNIP'] == true) {
          // Si ya tiene NIP, redirigir a la pantalla principal
          Navigator.pushReplacementNamed(context, '/GamePage');
        } else {
          // Si no tiene NIP, redirigir a la pantalla para configurarlo
          Navigator.pushReplacementNamed(context, '/WelcomeScreen');
        }

        // Almacenar usuarioId, token y NIP en el almacenamiento seguro
        await _storage.write(key: 'usuarioId', value: user['usuarioId']);
        await _storage.write(key: 'token', value: user['token']);
        await _storage.write(key: 'nip', value: user['nip'] ?? ''); // Guardar el NIP, si existe
        print('Usuario ID guardado: ${user['usuarioId']}');
        print('Token guardado: ${user['token']}');
        print('NIP guardado: ${user['nip']}');
      } else if (response.statusCode == 401) {
        _showSnackbar(context, "Error", "Correo o contraseña incorrectos.");
      } else {
        _showSnackbar(
          context,
          "Error",
          "Ha ocurrido un error. Usuario no encontrado.",
        );
      }
    } catch (e) {
      _showSnackbar(context, "Error", "Error de conexión. Intenta nuevamente.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Función para mostrar el Snackbar
  void _showSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            title == "Éxito" ? Icons.check_circle : Icons.error,
            color: title == "Éxito" ? Colors.green : Colors.red,
          ),
          SizedBox(width: 10),
          Text(message),
        ],
      ),
      backgroundColor: title == "Éxito" ? Colors.green[700] : Colors.red[700],
      duration: Duration(seconds: 1), // Duración de la alerta
    );

    // Mostrar el Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Función para verificar si el usuario está autenticado
  Future<void> _checkAuthentication() async {
    // Recuperar usuarioId, token y NIP desde el almacenamiento seguro
    String? usuarioId = await _storage.read(key: 'usuarioId');
    String? token = await _storage.read(key: 'token');
    String? nip = await _storage.read(key: 'nip');

    if (usuarioId == null || token == null) {
      setState(() {
        // Mensaje de error si no están autenticados
      });
      // Redirigir al login si no se encuentran
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Si está autenticado, puedes realizar alguna acción con el NIP si es necesario
      print('Usuario autenticado con NIP: $nip');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo_quoka.png', height: 100),
              SizedBox(height: 25),
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF232149),
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                emailController,
                'Correo electrónico',
                Icons.email_outlined,
              ),
              SizedBox(height: 15),
              _buildPasswordField(),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Redirigir a la pantalla de recuperación de contraseña
                    Navigator.pushNamed(context, '/recuperar_password');
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Color(0xFF471AA0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => loginUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF232149),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/registro'),
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Color(0xFF471AA0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'O inicia sesión con',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF232149)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('assets/images/facebook.png', () {}),
                  SizedBox(width: 25),
                  _buildSocialButton('assets/images/google.png', () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Color(0xFF471AA0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF471AA0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF471AA0), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      onChanged: (value) => setState(() => showEyeIcon = value.isNotEmpty),
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF471AA0)),
        suffixIcon:
            showEyeIcon
                ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF471AA0),
                  ),
                  onPressed:
                      () => setState(
                        () => isPasswordVisible = !isPasswordVisible,
                      ),
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF471AA0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF471AA0), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Image.asset(asset, height: 30),
      ),
    );
  }
}
