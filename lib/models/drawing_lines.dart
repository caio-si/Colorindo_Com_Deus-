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
    final linesData = json['lines'] as List? ?? [];
    final lines = linesData.map((lineData) {
      return (lineData as List).map((pointData) {
        final pointMap = Map<String, dynamic>.from(pointData);
        return DrawingPoint(
          position: pointMap['x'] != null && pointMap['y'] != null
              ? Offset(pointMap['x'].toDouble(), pointMap['y'].toDouble())
              : null,
          color: pointMap['color'] != null 
              ? Color(pointMap['color'] is int ? pointMap['color'] : int.tryParse(pointMap['color'].toString()) ?? 0)
              : null,
          tool: PaintingTool.values.firstWhere(
            (t) => t.name == pointMap['tool']?.toString(),
            orElse: () => PaintingTool.mediumBrush,
          ),
          brushSize: (pointMap['brushSize'] is double ? pointMap['brushSize'] : double.tryParse(pointMap['brushSize'].toString()) ?? 8.0),
        );
      }).toList();
    }).toList();

    return DrawingLines(lines: lines);
  }
}
