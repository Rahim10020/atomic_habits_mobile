import 'package:flutter/material.dart';

class CheckAnimation extends StatefulWidget {
  final bool isChecked;
  final bool isAnimating;
  final Color color;
  final double size;
  
  const CheckAnimation({
    super.key,
    required this.isChecked,
    required this.isAnimating,
    required this.color,
    this.size = 48,
  });
  
  @override
  State<CheckAnimation> createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<CheckAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    if (widget.isChecked) {
      _controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(CheckAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isAnimating && oldWidget.isChecked != widget.isChecked) {
      if (widget.isChecked) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(from: 1.0);
      }
    } else if (!widget.isAnimating) {
      if (widget.isChecked) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isChecked 
                  ? widget.color 
                  : Colors.transparent,
              border: Border.all(
                color: widget.color,
                width: 2.5,
              ),
            ),
            child: widget.isChecked
                ? CustomPaint(
                    painter: CheckPainter(
                      progress: _checkAnimation.value,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class CheckPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  CheckPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    // Define check mark path
    final p1 = Offset(size.width * 0.25, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.7);
    final p3 = Offset(size.width * 0.75, size.height * 0.3);
    
    // Calculate current end point based on progress
    if (progress < 0.5) {
      // First line (p1 to p2)
      final t = progress * 2;
      final currentX = p1.dx + (p2.dx - p1.dx) * t;
      final currentY = p1.dy + (p2.dy - p1.dy) * t;
      
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(currentX, currentY);
    } else {
      // Second line (p2 to p3)
      final t = (progress - 0.5) * 2;
      final currentX = p2.dx + (p3.dx - p2.dx) * t;
      final currentY = p2.dy + (p3.dy - p2.dy) * t;
      
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(currentX, currentY);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CheckPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
