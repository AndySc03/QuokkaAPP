import 'package:flutter/material.dart';

import 'ForgotPasswordPage.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final int code;

  const VerificationPage({super.key, required this.email, required this.code});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final codeController = TextEditingController();
  bool isVerifying = false;

  void _verifyCode() {
    setState(() {
      isVerifying = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isVerifying = false;
      });

      if (int.tryParse(codeController.text) == widget.code) {
        // Código correcto: Navegar a la pantalla para cambiar la contraseña
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      } else {
        // Código incorrecto: Mostrar error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('El código ingresado no es correcto.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Reintentar'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificación de Código'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF232149)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Ingresa el código enviado a ${widget.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Código de verificación',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifying ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF232149),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: isVerifying
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Verificar código', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
