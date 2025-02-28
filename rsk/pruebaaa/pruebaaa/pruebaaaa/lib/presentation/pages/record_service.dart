import 'package:record/record.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:platform/platform.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:android_content_provider/android_content_provider.dart';

class RecordService {
  bool _isRecording = false;
  final record = AudioRecorder();
  

  // Solicitar permisos solo para micrófono y acceso a archivos multimedia
  Future<bool> _requestPermissions() async {
    var micPermission = await Permission.microphone.request();
    var audioPermission = await Permission.audio.request();

    if (micPermission.isGranted && audioPermission.isGranted) {
      return true;
    } else {
      Logger().e("Permisos denegados.");
      return false;
    }
  }

  // Iniciar grabación y guardar en MediaStore
  Future<String?> startRecording() async {
    if (!await _requestPermissions()) {
      return null;
    }

    if (_isRecording) {
      Logger().w("Ya se está grabando, no se puede iniciar otra grabación.");
      return null;
    }

    try {
      String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      final uri = Uri.parse('content://media/external/audio/media');

    final values = {
      'display_name': fileName, 
      'mime_type': 'audio/m4a',
      'relative_path': 'Music/Recordings/'
    };

      if (uri == null) {
        Logger().e("No se pudo obtener la URI de MediaStore.");
        return null;
      }

      final filePath = uri.toString();
      
      await record.start(const RecordConfig(), path: filePath);

      _isRecording = true;
      Logger().i("Grabación iniciada en: $filePath");
      return filePath;
    } catch (e, s) {
      Logger().e('Error al iniciar la grabación:', error: e, stackTrace: s);
      return null;
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) {
      Logger().w("No hay grabación en curso para detener.");
      return null;
    }

    try {
      final path = await record.stop();
      _isRecording = false;

      final intent = AndroidIntent(
        action: 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        data: Uri.file(path!).toString(),
      );
      await intent.launch();

      Logger().i("Grabación detenida. Archivo guardado en: $path");
      return path;
    } catch (e, s) {
      Logger().e('Error al detener la grabación:', error: e, stackTrace: s);
      return null;
    }
  }

  bool get isRecording => _isRecording;

  Future<void> closeRecorder() async {
    await record.dispose();
  }
}
