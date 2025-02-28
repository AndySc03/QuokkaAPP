import 'package:flutter/material.dart';

class ViolentometroScreen extends StatefulWidget {
  const ViolentometroScreen({super.key});

  @override
  _ViolentometroScreenState createState() => _ViolentometroScreenState();
}

class _ViolentometroScreenState extends State<ViolentometroScreen> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Violentómetro'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nivel de violencia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Utiliza el control deslizante para indicar el nivel de violencia experimentado.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: _sliderValue.toStringAsFixed(0),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Nivel actual: ${_sliderValue.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón, como guardar o enviar el nivel
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,  // Se usa backgroundColor en lugar de 'primary'
              ),
              child: Text('Enviar Nivel'),
            ),
          ],
        ),
      ),
    );
  }
}
