import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/painting_tools.dart';
import '../providers/drawing_provider.dart';
import '../utils/app_colors.dart';

class EnhancedToolSelectorWidget extends StatefulWidget {
  const EnhancedToolSelectorWidget({Key? key}) : super(key: key);

  @override
  State<EnhancedToolSelectorWidget> createState() => _EnhancedToolSelectorWidgetState();
}

class _EnhancedToolSelectorWidgetState extends State<EnhancedToolSelectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animação de pulsação
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Animação de brilho
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, child) {
        return Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 8,
              ),
            ],
            border: Border.all(
              color: AppColors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.brush,
                        color: AppColors.primary,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ferramentas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Grid de ferramentas
              Expanded(
                child: Row(
                  children: PaintingTool.values.map((tool) {
                    final isSelected = drawingProvider.selectedTool == tool;
                    return Expanded(
                      child: _EnhancedToolButton(
                        tool: tool,
                        isSelected: isSelected,
                        pulseAnimation: _pulseAnimation,
                        shimmerAnimation: _shimmerAnimation,
                        onTap: () => drawingProvider.setSelectedTool(tool),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EnhancedToolButton extends StatelessWidget {
  final PaintingTool tool;
  final bool isSelected;
  final Animation<double> pulseAnimation;
  final Animation<double> shimmerAnimation;
  final VoidCallback onTap;

  const _EnhancedToolButton({
    Key? key,
    required this.tool,
    required this.isSelected,
    required this.pulseAnimation,
    required this.shimmerAnimation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulseAnimation, shimmerAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Transform.scale(
            scale: isSelected ? pulseAnimation.value : 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          AppColors.primary.withOpacity(0.9),
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ]
                      : [
                          Colors.white,
                          Colors.grey.shade50,
                          Colors.white,
                        ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  if (isSelected) ...[
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 8,
                      offset: const Offset(-2, -2),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 6,
                      offset: Offset(-2, -2),
                    ),
                  ],
                ],
                border: Border.all(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  // Efeito shimmer para ferramenta selecionada
                  if (isSelected)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Transform.translate(
                          offset: Offset(shimmerAnimation.value * 50, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Conteúdo do botão
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícone da ferramenta
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                        ],
                      ),
                      child: Icon(
                        tool.icon,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        size: tool.isEraser ? 14 : 16,
                        shadows: isSelected ? [
                          const Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ] : null,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Tamanho do pincel (visual)
                    if (!tool.isEraser)
                      Container(
                        width: 16,
                        height: 2,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    
                    const SizedBox(height: 2),
                    
                    // Nome da ferramenta
                    Text(
                      tool.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontSize: 8,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        shadows: isSelected ? [
                          const Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ] : null,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
