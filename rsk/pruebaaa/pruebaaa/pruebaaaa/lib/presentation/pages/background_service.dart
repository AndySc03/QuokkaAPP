// background_service.dart
import 'dart:isolate';

import 'record_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  late Isolate _isolate;
  late ReceivePort _receivePort;
  SendPort? _sendPort;
  final RecordService _recordService = RecordService();

  factory BackgroundService() {
    return _instance;
  }

  BackgroundService._internal();

  Future<void> startService() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_backgroundIsolate, _receivePort.sendPort);
    final sendPort = await _receivePort.first;
    if (sendPort is SendPort) {
      _sendPort = sendPort;
    } else {
      print('Error: No se pudo obtener SendPort');
    }
  }

  static void _backgroundIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    RecordService recordService = RecordService();

    await for (final message in receivePort) {
      if (message is String) {
        switch (message) {
          case 'start':
            await recordService.startRecording();
            break;
          case 'stop':
            await recordService.stopRecording();
            break;
        }
      }
    }
  }

  void sendMessageToIsolate(String message) {
    _sendPort?.send(message);
  }

  void startRecording() {
    sendMessageToIsolate('start');
  }

  void stopRecording() {
    sendMessageToIsolate('stop');
  }

  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
  }
}
