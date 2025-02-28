import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;  // Importa la librería http
import 'dart:convert';  // Para convertir datos a JSON
import 'mascota_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PinEntryScreen(),
    );
  }
}

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String nip = "";
  bool isLoading = false;
  String errorMessage = "";
  String usuarioId = "";
  String token = "";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getUsuarioIdAndToken();
  }

  Future<void> _getUsuarioIdAndToken() async {
    // Recuperar usuarioId y token desde Flutter Secure Storage
    usuarioId = await _secureStorage.read(key: 'usuarioId') ?? "";
    token = await _secureStorage.read(key: 'token') ?? "";

    setState(() {});
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == "clear") {
        if (nip.isNotEmpty) {
          nip = nip.substring(0, nip.length - 1);
        }
      } else {
        if (nip.length < 4) {
          nip += value;
        }
      }
    });
  }

  Future<void> _submitPin() async {
    if (nip.length != 4) {
      setState(() {
        errorMessage = "El NIP debe tener 4 dígitos.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      if (usuarioId.isEmpty || token.isEmpty) {
        setState(() {
          errorMessage = "Usuario no autenticado.";
        });
        return;
      }

      // Guardar el NIP en Secure Storage
      await _secureStorage.write(key: 'nip', value: nip);

      // Redirigir a la pantalla de confirmación
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfirmPinScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error de conexión. Intenta nuevamente.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 243, 173, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/Frame.png', height: 40),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                "Configura tu NIP",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(35, 33, 73, 1)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < nip.length ? const Color.fromARGB(255, 221, 118, 240) : Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildNumberPad(),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                errorMessage,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: nip.length == 4 ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size(300, 50),
                ),
                onPressed: nip.length == 4 && !isLoading ? _submitPin : null,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continuar",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    List<String> keys = [
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
      "", "0", "clear"
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          if (keys[index].isEmpty) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () => _onKeyPressed(keys[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: keys[index] == "clear"
                  ? const Icon(Icons.backspace, color: Color.fromRGBO(155, 70, 119, 1))
                  : Text(
                      keys[index],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  _ConfirmPinScreenState createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  String nip = "";
  String errorMessage = "";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> _getSavedPin() async {
    return await _secureStorage.read(key: 'nip') ?? "";
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == "clear") {
        if (nip.isNotEmpty) {
          nip = nip.substring(0, nip.length - 1);
        }
      } else {
        if (nip.length < 4) {
           nip += value;
        }
      }
    });
  }

  Future<void> _confirmPin() async {
    String savedPin = await _getSavedPin();

    if (nip.length != 4) {
      setState(() {
        errorMessage = "El NIP debe tener 4 dígitos.";
      });
      return;
    }

    if (nip != savedPin) {
      setState(() {
        errorMessage = "Los NIP no coinciden. Intenta nuevamente.";
      });
      return;
    }

    setState(() {
      errorMessage = "";
    });

    // Realizar la solicitud HTTP POST para guardar el NIP
    await _submitPinToServer();

    // Guardar el NIP en Secure Storage
    await _secureStorage.write(key: 'nip', value: nip);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Éxito"),
          content: const Text("NIP confirmado correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitPinToServer() async {
    final url = Uri.parse('https://quoka.onrender.com/auth/set-pin');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'usuarioId': await _secureStorage.read(key: 'usuarioId'),
      'nip': nip,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('NIP enviado correctamente');
      } else {
        print('Error al enviar NIP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 243, 173, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/Frame.png', height: 40),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Confirma tu NIP",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(35, 33, 73, 1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.all(8),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < nip.length
                      ? const Color.fromARGB(255, 221, 118, 240)
                      : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          _buildNumberPad(),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: nip.length == 4 ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(300, 50),
                ),
                onPressed: nip.length == 4 ? _confirmPin : null,
                child: const Text(
                  "Confirmar NIP",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    List<String> keys = [
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
      "", "0", "clear"
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          if (keys[index].isEmpty) return const SizedBox.shrink();
          return GestureDetector(
            onTap: () => _onKeyPressed(keys[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: keys[index] == "clear"
                  ? const Icon(Icons.backspace, color: Color.fromRGBO(155, 70, 119, 1))
                  : Text(
                      keys[index],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
            ),
          );
        },
      ),
    );
  }
}
