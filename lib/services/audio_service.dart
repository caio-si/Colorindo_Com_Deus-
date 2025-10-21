import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _soundPlayer = AudioPlayer();
  final AudioPlayer _narrationPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  
  bool _soundsEnabled = true;
  bool _narrationEnabled = true;
  bool _backgroundMusicEnabled = true;

  void setSoundsEnabled(bool enabled) {
    _soundsEnabled = enabled;
  }

  void setNarrationEnabled(bool enabled) {
    _narrationEnabled = enabled;
  }

  void setBackgroundMusicEnabled(bool enabled) {
    _backgroundMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
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

  Future<void> playBackgroundMusic() async {
    if (!_backgroundMusicEnabled) {
      print('🎵 Música de fundo desabilitada pelo usuário');
      return;
    }
    
    print('🎵 ===== DEBUG MÚSICA DE FUNDO =====');
    print('🎵 Status: Iniciando reprodução...');
    print('🎵 Caminho: audio/Music/background_music.mp3');
    print('🎵 Player: ${_backgroundMusicPlayer.runtimeType}');
    
    try {
      // Parar qualquer reprodução anterior
      print('🎵 Parando reprodução anterior...');
      await _backgroundMusicPlayer.stop();
      
      // Aguardar um pouco
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Configurar o player
      print('🎵 Configurando player...');
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(0.3);
      
      print('🎵 Tentando reproduzir arquivo...');
      // Tentar reproduzir
      await _backgroundMusicPlayer.play(AssetSource('audio/Music/background_music.mp3'));
      
      print('🎵 ✅ Música de fundo iniciada com sucesso!');
      print('🎵 ===== FIM DEBUG =====');
      
    } catch (e) {
      print('❌ ===== ERRO DETALHADO =====');
      print('❌ Erro principal: $e');
      print('❌ Tipo do erro: ${e.runtimeType}');
      
      if (e.toString().contains('DEMUXER_ERROR')) {
        print('❌ PROBLEMA: Arquivo MP3 corrompido ou formato inválido');
        print('❌ SOLUÇÃO: Verificar se o arquivo é um MP3 válido');
      } else if (e.toString().contains('404')) {
        print('❌ PROBLEMA: Arquivo não encontrado');
        print('❌ SOLUÇÃO: Verificar caminho do arquivo');
      } else if (e.toString().contains('Format error')) {
        print('❌ PROBLEMA: Formato de arquivo incompatível');
        print('❌ SOLUÇÃO: Converter para formato MP3 compatível');
      }
      
      // Tentar uma abordagem alternativa
      try {
        print('🔄 Tentando abordagem alternativa...');
        await _backgroundMusicPlayer.stop();
        await Future.delayed(const Duration(milliseconds: 500));
        
        print('🔄 Tentativa 2: Reproduzir novamente...');
        await _backgroundMusicPlayer.play(AssetSource('audio/Music/background_music.mp3'));
        print('🎵 ✅ Música iniciada na tentativa 2!');
        
      } catch (e2) {
        print('❌ Erro na tentativa 2: $e2');
        
        // Tentar parar qualquer reprodução em andamento
        try {
          await _backgroundMusicPlayer.stop();
        } catch (stopError) {
          print('❌ Erro ao parar música: $stopError');
        }
      }
      
      print('❌ ===== FIM ERRO DETALHADO =====');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundMusicPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_backgroundMusicEnabled) return;
    await _backgroundMusicPlayer.resume();
  }

  void dispose() {
    _soundPlayer.dispose();
    _narrationPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}

