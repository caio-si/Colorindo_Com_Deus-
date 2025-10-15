import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _soundPlayer = AudioPlayer();
  final AudioPlayer _narrationPlayer = AudioPlayer();
  
  bool _soundsEnabled = true;
  bool _narrationEnabled = true;

  void setSoundsEnabled(bool enabled) {
    _soundsEnabled = enabled;
  }

  void setNarrationEnabled(bool enabled) {
    _narrationEnabled = enabled;
  }

  Future<void> playPaintSound() async {
    if (!_soundsEnabled) return;
    
    try {
      await _soundPlayer.play(AssetSource('sounds/paint.mp3'));
    } catch (e) {
      // Ignore se o som não existir
    }
  }

  Future<void> playSuccessSound() async {
    if (!_soundsEnabled) return;
    
    try {
      await _soundPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      // Ignore se o som não existir
    }
  }

  Future<void> playNarration(String audioPath) async {
    if (!_narrationEnabled) return;
    
    try {
      await _narrationPlayer.play(AssetSource(audioPath));
    } catch (e) {
      // Ignore se o áudio não existir
    }
  }

  Future<void> stopNarration() async {
    await _narrationPlayer.stop();
  }

  void dispose() {
    _soundPlayer.dispose();
    _narrationPlayer.dispose();
  }
}

