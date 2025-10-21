import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../providers/drawing_provider.dart';
import 'package:provider/provider.dart';

class ClayColorPaletteWidget extends StatefulWidget {
  const ClayColorPaletteWidget({Key? key}) : super(key: key);

  @override
  State<ClayColorPaletteWidget> createState() => _ClayColorPaletteWidgetState();
}

class _ClayColorPaletteWidgetState extends State<ClayColorPaletteWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, child) {
        return Container(
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // Cor de fundo clay
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              // Sombra externa para efeito clay
              BoxShadow(
                color: Color(0xFFD0D0D0),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: SizedBox(
            height: 200, // Altura fixa para permitir scroll
            child: Scrollbar(
              thumbVisibility: true, // Scrollbar sempre visível
              thickness: 8, // Espessura da scrollbar
              radius: const Radius.circular(4),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: AppColors.paintColors.map((color) {
                    return _ClayColorBubble(
                      color: color,
                      isSelected: drawingProvider.selectedColor == color,
                      onTap: () => drawingProvider.setSelectedColor(color),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ClayColorBubble extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClayColorBubble({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_ClayColorBubble> createState() => _ClayColorBubbleState();
}

class _ClayColorBubbleState extends State<_ClayColorBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnim = Tween<double>(begin: 1, end: 1.15)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _controller.reverse,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: widget.isSelected 
                      ? Colors.white.withOpacity(0.8)
                      : Colors.white.withOpacity(0.3),
                  width: widget.isSelected ? 3 : 2,
                ),
                boxShadow: [
                  // Sombra escura (direita/baixo)
                  BoxShadow(
                    color: Colors.grey.shade600.withOpacity(0.4),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  // Sombra clara (esquerda/cima)
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  // Brilho da cor
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: -1,
                    offset: const Offset(1, 1),
                  ),
                  // Sombra de seleção
                  if (widget.isSelected)
                    BoxShadow(
                      color: widget.color.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: widget.isSelected
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.9),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
