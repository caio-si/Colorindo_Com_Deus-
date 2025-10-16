import 'package:flutter/material.dart';
import '../widgets/free_drawing_canvas.dart';
import '../utils/painting_tools.dart';

class DrawingLines {
  final List<List<DrawingPoint>> lines;

  DrawingLines({required this.lines});

  Map<String, dynamic> toJson() {
    return {
      'lines': lines.map((line) => 
        line.map((point) => {
          'x': point.position?.dx,
          'y': point.position?.dy,
          'color': point.color?.value,
          'tool': point.tool.name,
          'brushSize': point.brushSize,
        }).toList()
      ).toList(),
    };
  }

  factory DrawingLines.fromJson(Map<String, dynamic> json) {
    final linesData = json['lines'] as List;
    final lines = linesData.map((lineData) {
      return (lineData as List).map((pointData) {
        return DrawingPoint(
          position: pointData['x'] != null && pointData['y'] != null
              ? Offset(pointData['x'].toDouble(), pointData['y'].toDouble())
              : null,
          color: pointData['color'] != null 
              ? Color(pointData['color']) 
              : null,
          tool: PaintingTool.values.firstWhere(
            (t) => t.name == pointData['tool'],
            orElse: () => PaintingTool.mediumBrush,
          ),
          brushSize: pointData['brushSize']?.toDouble() ?? 8.0,
        );
      }).toList();
    }).toList();

    return DrawingLines(lines: lines);
  }
}
