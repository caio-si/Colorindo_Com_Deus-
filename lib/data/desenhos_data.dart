import 'package:flutter/material.dart';
import '../models/desenho.dart';

class DesenhosData {
  static List<Desenho> obterDesenhos() {
    return [
      _criarDesenhoSimples('desenho_1', '1', 'Criação do Mundo'),
      _criarDesenhoSimples('desenho_2', '2', 'Noé e a Arca'),
      _criarDesenhoSimples('desenho_3', '3', 'Davi e Golias'),
      _criarDesenhoSimples('desenho_4', '4', 'Jonas e o Grande Peixe'),
      _criarDesenhoSimples('desenho_5', '5', 'Daniel na Cova dos Leões'),
      _criarDesenhoSimples('desenho_6', '6', 'Nascimento de Jesus'),
      _criarDesenhoSimples('desenho_7', '7', 'Jesus Acalma a Tempestade'),
      _criarDesenhoSimples('desenho_8', '8', 'Multiplicação dos Pães'),
      _criarDesenhoSimples('desenho_9', '9', 'O Bom Samaritano'),
      _criarDesenhoSimples('desenho_10', '10', 'Zaqueu na Árvore'),
    ];
  }

  static Desenho _criarDesenhoSimples(String id, String historiaId, String titulo) {
    // Criar áreas de exemplo (em produção, estas viriam de arquivos SVG)
    final areas = _criarAreasExemplo(id);
    
    return Desenho(
      id: id,
      historiaId: historiaId,
      titulo: titulo,
      imagemPath: 'assets/images/drawings/$id.png',
      miniaturaPath: 'assets/images/drawings/${id}_thumb.png',
      areas: areas,
    );
  }

  static List<DesenhoArea> _criarAreasExemplo(String desenhoId) {
    // Criar áreas de colorir mais específicas e menores
    // Em produção, estas seriam carregadas de arquivos SVG ou JSON
    List<DesenhoArea> areas = [];
    
    // Áreas menores e mais específicas para diferentes elementos do desenho
    final areasConfig = [
      // Céu e elementos do céu
      {'x': 50, 'y': 50, 'w': 80, 'h': 80, 'name': 'sol'}, // Sol
      {'x': 150, 'y': 80, 'w': 60, 'h': 60, 'name': 'nuvem1'}, // Nuvem 1
      {'x': 200, 'y': 70, 'w': 60, 'h': 60, 'name': 'nuvem2'}, // Nuvem 2
      {'x': 100, 'y': 120, 'w': 120, 'h': 20, 'name': 'arco_iris'}, // Arco-íris
      
      // Arca
      {'x': 80, 'y': 200, 'w': 180, 'h': 100, 'name': 'arca_corpo'}, // Corpo da arca
      {'x': 120, 'y': 180, 'w': 100, 'h': 40, 'name': 'arca_cabana'}, // Cabana da arca
      {'x': 140, 'y': 190, 'w': 20, 'h': 20, 'name': 'janela'}, // Janela da arca
      
      // Animais na arca
      {'x': 90, 'y': 210, 'w': 40, 'h': 60, 'name': 'elefante'}, // Elefante
      {'x': 130, 'y': 200, 'w': 30, 'h': 40, 'name': 'macaco'}, // Macaco
      {'x': 160, 'y': 190, 'w': 20, 'h': 50, 'name': 'girafa'}, // Girafa
      
      // Animais na rampa
      {'x': 270, 'y': 250, 'w': 40, 'h': 50, 'name': 'leao'}, // Leão
      {'x': 270, 'y': 300, 'w': 40, 'h': 50, 'name': 'zebra'}, // Zebra
      {'x': 270, 'y': 350, 'w': 40, 'h': 40, 'name': 'ovelha'}, // Ovelha
      
      // Água
      {'x': 50, 'y': 320, 'w': 300, 'h': 30, 'name': 'agua'}, // Água
      
      // Pássaro
      {'x': 180, 'y': 150, 'w': 15, 'h': 15, 'name': 'passaro'}, // Pássaro
    ];
    
    for (int i = 0; i < areasConfig.length; i++) {
      final config = areasConfig[i];
      final x = (config['x'] as int).toDouble();
      final y = (config['y'] as int).toDouble();
      final w = (config['w'] as int).toDouble();
      final h = (config['h'] as int).toDouble();
      final name = config['name'] as String;
      
      areas.add(DesenhoArea(
        id: '${desenhoId}_${name}',
        path: Path()
          ..addRect(Rect.fromLTWH(x, y, w, h)),
        bounds: Rect.fromLTWH(x, y, w, h),
      ));
    }
    
    return areas;
  }

  static Desenho? obterDesenhoPorId(String id) {
    final desenhos = obterDesenhos();
    try {
      return desenhos.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }
}

