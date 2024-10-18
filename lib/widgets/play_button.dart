import 'package:flutter/material.dart';

class TimerActionButton extends StatelessWidget {
  const TimerActionButton({
    super.key,
    required this.onPressed,
    required this.size,
    required this.icon,
    required this.backgroundColor,
    required this.color,
  });
  final void Function()? onPressed;
  final double size;
  final IconData icon;
  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
          disabledColor: color.withOpacity(0.1),
          color: color,
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
          )),
    );
  }
}
