import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import '../utils/painting_tools.dart';
import '../utils/app_colors.dart';

class ToolSelectorWidget extends StatelessWidget {
  const ToolSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final drawingProvider = Provider.of<DrawingProvider>(context);

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ferramentas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: PaintingTool.values.map((tool) {
                final isSelected = tool == drawingProvider.selectedTool;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => drawingProvider.setSelectedTool(tool),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tool.icon,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tool.displayName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontSize: 9,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
