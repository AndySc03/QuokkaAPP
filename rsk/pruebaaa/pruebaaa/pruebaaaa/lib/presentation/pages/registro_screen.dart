import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Paso A: Clase para eliminar glow
class NoGlowScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Quita el glow
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool acceptTerms = false;
  bool isLoading = false;
  bool isPasswordStarted = false;
  String passwordStrength = 'Baja';
  Color passwordStrengthColor = Colors.red;
  bool isPasswordVisible = false; // Variable para mostrar/ocultar la contraseña
  bool showEyeIcon = false; // Variable para mostrar el ícono del ojo

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  void _measurePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        passwordStrength = 'Baja';
        passwordStrengthColor = Colors.red;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        passwordStrength = 'Baja';
        passwordStrengthColor = Colors.red;
      });
    } else if (password.length >= 6 && password.length < 8) {
      setState(() {
        passwordStrength = 'Media';
        passwordStrengthColor = Colors.orange;
      });
    } else if (_isPasswordValid(password)) {
      setState(() {
        passwordStrength = 'Alta';
        passwordStrengthColor = Colors.green;
      });
    } else {
      setState(() {
        passwordStrength = 'Media';
        passwordStrengthColor = Colors.orange;
      });
    }
  }

  Future<void> registerUser(BuildContext context) async {
    if (_validateForm(context)) {
      setState(() => isLoading = true);

      final url = Uri.parse('https://quoka.onrender.com/auth/register');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombre': nameController.text,
            'correo': emailController.text,
            'telefono': phoneController.text,
            'contrasena': passwordController.text,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          _showSnackbar(context, "Éxito", "Registro completado.");
        } else {
          _showSnackbar(
            context,
            "Error",
            "Error en el registro. Intenta nuevamente.",
          );
        }
      } catch (e) {
        _showSnackbar(
          context,
          "Error",
          "Error de conexión. Intenta nuevamente.",
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  bool _validateForm(BuildContext context) {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showSnackbar(context, "Error", "Por favor, llena todos los campos.");
      return false;
    }

    if (!acceptTerms) {
      _showSnackbar(
        context,
        "Aviso",
        "Debes aceptar los términos y condiciones.",
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnackbar(context, "Error", "Las contraseñas no coinciden.");
      return false;
    }

    if (!RegExp(
      r'^[a-zA-Z0-9_]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    ).hasMatch(emailController.text)) {
      _showSnackbar(
        context,
        "Error",
        "Por favor, ingresa un correo electrónico válido.",
      );
      return false;
    }

    return true;
  }

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
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Método para crear el botón social
  Widget _buildSocialButton(String imagePath, Function onPressed) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Método para mostrar la ventana emergente de Políticas de Privacidad
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Políticas de Privacidad para Quoka'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'En Quoka, valoramos tu privacidad y seguridad. Esta Política de Privacidad está diseñada para informarte sobre cómo recopilamos, utilizamos, protegemos y compartimos tu información mientras utiliza nuestra aplicación.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Información que Recopilamos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Quoka recopila información únicamente para brindar una experiencia segura y funcional a sus usuarios.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '2. Uso de la información',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Los datos recopilados se utilizan para las siguientes finalidades: funcionalidad de la aplicación, seguridad, mejora de la experiencia.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '3. Almacenamiento y Seguridad de la Información',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Toda la información recogida a través de Quoka se almacena de forma segura en servidores cifrados.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                // ... Agrega el resto de la política de privacidad aquí ...
                SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          acceptTerms = true; // Acepta los términos
                        });
                        Navigator.of(context).pop(); // Cierra la ventana
                      },
                      child: Text('Aceptar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop(); // Cierra la ventana sin aceptar
                      },
                      child: Text('Cerrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
      ),
      // Paso B: ScrollConfiguration para eliminar overscroll glow
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo_quoka.png',
                height: 80,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF232149),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              _buildTextField(
                nameController,
                'Nombre completo',
                Icons.person_outline,
              ),
              SizedBox(height: 10),
              _buildTextField(
                emailController,
                'Correo electrónico',
                Icons.email_outlined,
              ),
              SizedBox(height: 10),
              _buildPhoneField(),
              SizedBox(height: 10),
              _buildPasswordField(passwordController, 'Contraseña'),
              SizedBox(height: 10),
              if (isPasswordStarted)
                Text(
                  'Fuerza de la contraseña: $passwordStrength',
                  style: TextStyle(color: passwordStrengthColor),
                ),
              SizedBox(height: 10),
              _buildPasswordField(
                confirmPasswordController,
                'Confirmar contraseña',
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    activeColor: Color(0xFF471AA0),
                    value: acceptTerms,
                    onChanged: (value) => setState(() => acceptTerms = value!),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showPrivacyPolicy(context);
                      },
                      child: Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(
                          color: Color(0xFF471AA0),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading ? null : () => registerUser(context),
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
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Ya tienes cuenta? "),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Inicia sesión',
                      style: TextStyle(color: Color(0xFF471AA0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Agregando los botones sociales
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('assets/images/facebook.png', () {
                    // Lógica para el botón de Facebook
                  }),
                  SizedBox(width: 15),
                  _buildSocialButton('assets/images/google.png', () {
                    // Lógica para el botón de Google
                  }),
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

  Widget _buildPhoneField() {
    return TextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        hintText: 'Teléfono',
        prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF471AA0)),
        counterText: "",
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

  Widget _buildPasswordField(
    TextEditingController controller,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      onChanged: (value) {
        setState(() {
          isPasswordStarted = value.isNotEmpty;
          showEyeIcon = value.isNotEmpty;
        });
        _measurePasswordStrength(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
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
}
