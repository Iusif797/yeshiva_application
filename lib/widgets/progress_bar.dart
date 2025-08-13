import 'package:flutter/material.dart';

class LessonProgressBar extends StatelessWidget {
  final double value;
  const LessonProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            AnimatedContainer(duration: const Duration(milliseconds: 300), width: double.infinity, color: Colors.transparent),
            LayoutBuilder(builder: (ctx, constraints) {
              final w = constraints.maxWidth * value.clamp(0.0, 1.0);
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: w,
                  height: 12,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)]),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}


