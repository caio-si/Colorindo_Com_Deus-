import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/desenho.dart';
import '../models/progresso_usuario.dart';
import '../utils/paint_modes.dart';

class DrawingProvider extends ChangeNotifier {
  final Box _progressBox = Hive.box('progress');
  final Uuid _uuid = const Uuid();
  
  Desenho? _currentDesenho;
  ProgressoUsuario? _currentProgress;
  Color _selectedColor = Colors.red;
  PaintMode _paintMode = PaintMode.guided;
  String? _selectedAreaId;
  
  final List<Map<String, int>> _undoStack = [];
  final List<Map<String, int>> _redoStack = [];

  Desenho? get currentDesenho => _currentDesenho;
  ProgressoUsuario? get currentProgress => _currentProgress;
  Color get selectedColor => _selectedColor;
  PaintMode get paintMode => _paintMode;
  String? get selectedAreaId => _selectedAreaId;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setPaintMode(PaintMode mode) {
    _paintMode = mode;
    _selectedAreaId = null; // Limpa seleção ao mudar modo
    notifyListeners();
  }

  void selectArea(String areaId) {
    if (_paintMode == PaintMode.guided) {
      _selectedAreaId = areaId;
      notifyListeners();
    }
  }

  void clearAreaSelection() {
    _selectedAreaId = null;
    notifyListeners();
  }

  Future<void> loadDesenho(Desenho desenho) async {
    _currentDesenho = desenho;
    
    // Carregar progresso existente ou criar novo
    final progressData = _progressBox.get('progress_${desenho.id}');
    
    if (progressData != null) {
      _currentProgress = ProgressoUsuario.fromJson(
        Map<String, dynamic>.from(progressData),
      );
    } else {
      _currentProgress = ProgressoUsuario(
        id: _uuid.v4(),
        desenhoId: desenho.id,
        areasColoridas: {},
        dataModificacao: DateTime.now(),
      );
    }
    
    // Aplicar cores salvas ao desenho
    if (_currentProgress != null) {
      for (var area in desenho.areas) {
        final corSalva = _currentProgress!.areasColoridas[area.id];
        if (corSalva != null) {
          area.corPreenchida = Color(corSalva);
        }
      }
    }
    
    _undoStack.clear();
    _redoStack.clear();
    
    notifyListeners();
  }

  void colorirArea(String areaId) {
    // No modo livre, pinta diretamente
    if (_paintMode == PaintMode.free) {
      _pintarArea(areaId);
    }
    // No modo guiado, apenas seleciona a área
    else if (_paintMode == PaintMode.guided) {
      selectArea(areaId);
    }
  }

  void colorirAreaSelecionada() {
    if (_selectedAreaId != null) {
      _pintarArea(_selectedAreaId!);
      _selectedAreaId = null; // Limpa seleção após pintar
    }
  }

  void _pintarArea(String areaId) {
    if (_currentDesenho == null || _currentProgress == null) return;
    
    // Salvar estado atual para undo
    _undoStack.add(Map.from(_currentProgress!.areasColoridas));
    _redoStack.clear();
    
    // Aplicar nova cor
    final area = _currentDesenho!.areas.firstWhere((a) => a.id == areaId);
    area.corPreenchida = _selectedColor;
    
    // Atualizar progresso
    _currentProgress = _currentProgress!.copyWith(
      areasColoridas: {
        ..._currentProgress!.areasColoridas,
        areaId: _selectedColor.value,
      },
      dataModificacao: DateTime.now(),
    );
    
    notifyListeners();
  }

  void apagarCor(String areaId) {
    if (_currentDesenho == null || _currentProgress == null) return;
    
    _undoStack.add(Map.from(_currentProgress!.areasColoridas));
    _redoStack.clear();
    
    final area = _currentDesenho!.areas.firstWhere((a) => a.id == areaId);
    area.corPreenchida = null;
    
    final novasAreas = Map<String, int>.from(_currentProgress!.areasColoridas);
    novasAreas.remove(areaId);
    
    _currentProgress = _currentProgress!.copyWith(
      areasColoridas: novasAreas,
      dataModificacao: DateTime.now(),
    );
    
    notifyListeners();
  }

  void undo() {
    if (!canUndo) return;
    
    _redoStack.add(Map.from(_currentProgress!.areasColoridas));
    final previousState = _undoStack.removeLast();
    
    _currentProgress = _currentProgress!.copyWith(
      areasColoridas: previousState,
      dataModificacao: DateTime.now(),
    );
    
    // Atualizar áreas do desenho
    if (_currentDesenho != null) {
      for (var area in _currentDesenho!.areas) {
        final cor = previousState[area.id];
        area.corPreenchida = cor != null ? Color(cor) : null;
      }
    }
    
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    
    _undoStack.add(Map.from(_currentProgress!.areasColoridas));
    final nextState = _redoStack.removeLast();
    
    _currentProgress = _currentProgress!.copyWith(
      areasColoridas: nextState,
      dataModificacao: DateTime.now(),
    );
    
    // Atualizar áreas do desenho
    if (_currentDesenho != null) {
      for (var area in _currentDesenho!.areas) {
        final cor = nextState[area.id];
        area.corPreenchida = cor != null ? Color(cor) : null;
      }
    }
    
    notifyListeners();
  }

  Future<void> salvarProgresso() async {
    if (_currentProgress == null) return;
    
    await _progressBox.put(
      'progress_${_currentProgress!.desenhoId}',
      _currentProgress!.toJson(),
    );
  }

  Future<void> finalizarDesenho() async {
    if (_currentProgress == null) return;
    
    _currentProgress = _currentProgress!.copyWith(
      finalizado: true,
      dataModificacao: DateTime.now(),
    );
    
    await salvarProgresso();
    notifyListeners();
  }

  void limparDesenho() {
    _currentDesenho = null;
    _currentProgress = null;
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }
}

