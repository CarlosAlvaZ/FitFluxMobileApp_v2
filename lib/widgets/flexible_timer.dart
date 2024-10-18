import 'dart:async';
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/widgets/play_button.dart';
import 'package:fit_flux_mobile_app_v2/widgets/timer_button_with_label.dart';
import 'package:flutter/material.dart';

class FlexibleTimer extends StatefulWidget {
  const FlexibleTimer(
      {super.key,
      required this.excercise,
      required this.previous,
      required this.next,
      required this.restartSession,
      required this.finishSession});
  final Excercise excercise;
  final void Function()? previous;
  final void Function()? next;
  final void Function()? restartSession;
  final void Function()? finishSession;

  @override
  State<FlexibleTimer> createState() => _FlexibleTimerState();
}

class _FlexibleTimerState extends State<FlexibleTimer> {
  int _seconds = 0;

  Timer? _timer;

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _resetTime();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void _resetTime() {
    setState(() => _seconds = 0);
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
  }

  Widget _buildTime() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CircularProgressIndicator(
            value: 100,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: Text(
              "$_seconds",
              style: context.textTheme.displayLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    final isRunning = _timer == null ? false : _isRunning;

    if (isRunning) {
      return TimerActionButton(
          onPressed: () {
            _stopTimer();
          },
          icon: Icons.pause_rounded,
          size: 80,
          backgroundColor: AppColors.extraSecondary,
          color: Colors.white);
    } else {
      return TimerActionButton(
          onPressed: () {
            _startTimer();
          },
          icon: Icons.play_arrow_rounded,
          size: 80,
          backgroundColor: AppColors.extraSecondary,
          color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTime(),
        const SizedBox(
          height: 32,
        ),
        Text(
          widget.excercise.name,
          style: context.textTheme.headlineLarge,
        ),
        Text(widget.excercise.description,
            style: context.textTheme.displaySmall!
                .copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimerActionButton(
                onPressed: widget.previous,
                size: 48,
                icon: Icons.first_page_rounded,
                backgroundColor: Colors.white70,
                color: AppColors.extraPrimary),
            const SizedBox(
              width: 24,
            ),
            _buildMainButton(),
            const SizedBox(
              width: 24,
            ),
            widget.next == null
                ? Container()
                : TimerActionButton(
                    onPressed: widget.next,
                    size: 48,
                    icon: Icons.last_page_rounded,
                    backgroundColor: Colors.white70,
                    color: AppColors.extraPrimary),
          ],
        ),
        const SizedBox(
          height: 48,
        ),
        _timer == null || !_timer!.isActive
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TimerButtonWithLabel(
                    onPressed: () => _resetTime(),
                    icon: Icons.replay_rounded,
                    backgroundColor: Colors.white54,
                    color: AppColors.extraSecondary,
                    size: 36,
                    width: 72,
                    label: "Reniciar ejercicio",
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  TimerButtonWithLabel(
                    onPressed: widget.restartSession,
                    icon: Icons.rotate_left_rounded,
                    backgroundColor: AppColors.extraQuinary,
                    color: Colors.white,
                    size: 36,
                    width: 72,
                    label: "Reniciar Sesión",
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  TimerButtonWithLabel(
                    onPressed: widget.finishSession,
                    icon: Icons.clear_rounded,
                    backgroundColor: AppColors.redSecondary,
                    color: Colors.white,
                    size: 36,
                    width: 72,
                    label: "Finalizar Sesión",
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
