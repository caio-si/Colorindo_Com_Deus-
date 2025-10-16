import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/progresso_usuario.dart';

class GalleryProvider extends ChangeNotifier {
  final Box _galleryBox = Hive.box('gallery');
  final Box _progressBox = Hive.box('progress');
  
  List<ProgressoUsuario> _desenhosFinalizados = [];
  List<ProgressoUsuario> _desenhosEmProgresso = [];

  List<ProgressoUsuario> get desenhosFinalizados => _desenhosFinalizados;
  List<ProgressoUsuario> get desenhosEmProgresso => _desenhosEmProgresso;

  GalleryProvider() {
    carregarGaleria();
  }

  Future<void> carregarGaleria() async {
    _desenhosFinalizados = [];
    _desenhosEmProgresso = [];
    
    // Carregar todos os progressos
    final keys = _progressBox.keys.toList();
    
    for (var key in keys) {
      final data = _progressBox.get(key);
      if (data != null) {
        final progresso = ProgressoUsuario.fromJson(
          Map<String, dynamic>.from(data),
        );
        
        if (key.toString().startsWith('finalized_')) {
          // Desenhos finalizados
          _desenhosFinalizados.add(progresso);
        } else if (key.toString().startsWith('progress_')) {
          // Desenhos em andamento (com progresso)
          if (progresso.areasColoridas.isNotEmpty || 
              (progresso.drawingLines != null && progresso.drawingLines!.lines.isNotEmpty)) {
            _desenhosEmProgresso.add(progresso);
          }
        }
      }
    }
    
    // Ordenar por data de modificação
    _desenhosFinalizados.sort((a, b) => 
      b.dataModificacao.compareTo(a.dataModificacao)
    );
    _desenhosEmProgresso.sort((a, b) => 
      b.dataModificacao.compareTo(a.dataModificacao)
    );
    
    notifyListeners();
  }

  Future<void> salvarNaGaleria(ProgressoUsuario progresso, String imagePath) async {
    await _galleryBox.put(progresso.id, {
      'progressoId': progresso.id,
      'desenhoId': progresso.desenhoId,
      'imagePath': imagePath,
      'dataSalvamento': DateTime.now().toIso8601String(),
    });
    
    await carregarGaleria();
  }

  Future<void> excluirDesenho(String progressoId) async {
    await _galleryBox.delete(progressoId);
    
    // Buscar e deletar o progresso correspondente
    final keys = _progressBox.keys.toList();
    for (var key in keys) {
      final data = _progressBox.get(key);
      if (data != null) {
        final progresso = ProgressoUsuario.fromJson(
          Map<String, dynamic>.from(data),
        );
        if (progresso.id == progressoId) {
          await _progressBox.delete(key);
          break;
        }
      }
    }
    
    await carregarGaleria();
  }

  String? getImagePath(String progressoId) {
    final data = _galleryBox.get(progressoId);
    if (data != null) {
      return data['imagePath'];
    }
    return null;
  }
}

