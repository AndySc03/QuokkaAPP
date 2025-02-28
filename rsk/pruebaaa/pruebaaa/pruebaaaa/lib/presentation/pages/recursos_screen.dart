import 'package:flutter/material.dart';

class RecursosScreen extends StatelessWidget {
  final List<Map<String, String>> recursos = [
    {
      'title': 'Línea Nacional contra la Violencia de Género',
      'description': 'Llama al 800-123-4567 para recibir ayuda inmediata.',
      'url': 'https://www.violencia.gob.mx',
    },
    {
      'title': 'Refugio de Mujeres',
      'description': 'Espacios seguros para mujeres en riesgo.',
      'url': 'https://www.refugio-mujeres.org',
    },
    {
      'title': 'Asesoría Legal Gratuita',
      'description': 'Obtén asesoría legal gratuita sobre violencia doméstica.',
      'url': 'https://www.asesoria-legal.org',
    },
    // Puedes agregar más recursos aquí
  ];

   RecursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recursos'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recursos.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  recursos[index]['title']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  recursos[index]['description']!,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.open_in_new),
                onTap: () {
                  // Abrir el enlace del recurso en el navegador
                  _launchURL(recursos[index]['url']!);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Lógica para abrir el enlace en un navegador (se puede usar un paquete como url_launcher)
    print('Abriendo: $url');
    // Puedes integrar un paquete como 'url_launcher' para abrir la URL real.
  }
}
