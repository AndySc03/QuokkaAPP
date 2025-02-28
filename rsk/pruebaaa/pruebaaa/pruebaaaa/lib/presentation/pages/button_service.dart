import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';
import 'package:flutter/services.dart';

class ButtonService with WidgetsBindingObserver {
  Function onCombinationPressed;
  int _volumeCounter = 0;
  int _powerCounter = 0;

  ButtonService({required this.onCombinationPressed}) {
    _startListening();
  }

  void _startListening() {
    VolumeWatcher.addListener((volume) {
      _volumeCounter++;
      _checkCombination();
    });
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.power) {
      _powerCounter++;
      _checkCombination();
    }
  }

  void _checkCombination() {
    if (_powerCounter >= 1 && _volumeCounter >= 1) {
      onCombinationPressed();
      _powerCounter = 0;
      _volumeCounter = 0;
    }
  }
}
