import 'package:flutter/material.dart';
import 'package:pruebaaaa/presentation/pages/record_service.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class EvidenciasScreen extends StatefulWidget {
  const EvidenciasScreen({super.key});

  @override
  _EvidenciasScreenState createState() => _EvidenciasScreenState();
}

class _EvidenciasScreenState extends State<EvidenciasScreen> {
  final RecordService recorder = RecordService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;
  List<String> recordedFiles = []; // Lista para almacenar las grabaciones

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _requestPermissions() async {
  var statusMic = await Permission.microphone.request();

  if (statusMic.isGranted) {
    return true;
  } else {
    Logger().e("Permiso de micrófono no concedido.");
    return false;
  }
}



  void startRecording() async {
    if (await _requestPermissions()) {
      String? path = await recorder.startRecording();
      if (path != null) {
        setState(() {
          isRecording = true;
        });
        Logger().i('Grabación iniciada en: $path');
      } else {
        Logger().e('No se pudo iniciar la grabación');
      }
    }
  }

  void stopRecording() async {
    String? path = await recorder.stopRecording();
    if (path != null) {
      setState(() {
        isRecording = false;
        recordedFiles.add(path); // Agregar la grabación a la lista
      });
      Logger().i('Grabación detenida. Archivo guardado en: $path');
    } else {
      Logger().e('No se pudo detener la grabación');
    }
  }

  void playAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
    Logger().i("Reproduciendo audio: $path");
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Evidencias'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  isRecording ? 'Grabando...' : 'Listo para grabar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(isRecording ? Icons.stop : Icons.mic),
                  onPressed: () => isRecording ? stopRecording() : startRecording(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recordedFiles.isEmpty
                  ? Center(child: Text("No hay grabaciones aún"))
                  : ListView.builder(
                      itemCount: recordedFiles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text('Grabación ${index + 1}'),
                            subtitle: Text(recordedFiles[index]),
                            trailing: IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () => playAudio(recordedFiles[index]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
