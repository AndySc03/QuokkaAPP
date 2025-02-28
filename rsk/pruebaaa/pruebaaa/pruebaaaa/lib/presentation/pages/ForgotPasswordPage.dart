import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para convertir los datos a formato JSON

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String verificationCode = '';
  bool codeSent = false;
  bool codeVerified = false;

  String generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // Código de 6 dígitos
  }

  void sendEmail(String email) async {
    String username = 'soportequoka@gmail.com';
    String password = 'gpch acfn oemt crkl';

    final smtpServer = gmail(username, password);
    verificationCode = generateVerificationCode();

    final message =
        Message()
          ..from = Address(username, 'Soporte Quoka')
          ..recipients.add(email)
          ..subject = 'Recuperación de contraseña'
          ..html = """
      <div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px; text-align: center;'>
        <h2 style='color: #007BFF;'>Recuperación de contraseña</h2>
        <p>Hola,</p>
        <p>Hemos recibido una solicitud para restablecer tu contraseña. Usa el siguiente código para completar el proceso:</p>
        <h3 style='background: #007BFF; color: white; display: inline-block; padding: 10px 20px; border-radius: 5px;'>$verificationCode</h3>
        <p>Si no realizaste esta solicitud, ignora este mensaje.</p>
        <p style='color: #888;'>Equipo de soporte Quoka</p>
      </div>
      """;

    try {
      await send(message, smtpServer);
      setState(() {
        codeSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correo enviado. Revisa tu bandeja de entrada.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el correo: ${e.toString()}')),
      );
    }
  }

  void verifyCode() {
    if (codeController.text == verificationCode) {
      setState(() {
        codeVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código verificado correctamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código incorrecto, intenta nuevamente.')),
      );
    }
  }

  void changePassword() async {
    if (codeVerified) {
      String newPassword = newPasswordController.text;

      // Realiza una solicitud POST a tu API para cambiar la contraseña
      final url = Uri.parse('https://quoka.onrender.com/usuarios/cambiar-contrasena');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña cambiada con éxito.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cambiar la contraseña.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Contraseña')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  codeSent ? null : () => sendEmail(emailController.text),
              child: Text('Enviar Código'),
            ),
            if (codeSent) ...[
              SizedBox(height: 20),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Código de verificación',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyCode,
                child: Text('Verificar Código'),
              ),
            ],
            if (codeVerified) ...[
              SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: changePassword,
                child: Text('Cambiar Contraseña'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
