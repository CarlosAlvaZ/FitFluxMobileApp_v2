import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton(
      {super.key,
      this.width,
      this.height,
      this.color = Colors.white24,
      this.baseColor = Colors.white38,
      this.highlightColor = Colors.white60});

  final double? width, height;
  final Color color, baseColor, highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: highlightColor,
      highlightColor: baseColor,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}
