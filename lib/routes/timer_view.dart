import 'dart:async';

import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/models/active_session.dart';
import 'package:fit_flux_mobile_app_v2/models/session.dart';
import 'package:fit_flux_mobile_app_v2/utils/logger.dart' show logger;
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/widgets/flexible_timer.dart';
import 'package:fit_flux_mobile_app_v2/widgets/main_timer.dart';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  List<Excercise>? _excercises;
  Excercise? _currentExcercise;
  Session? _session;
  ActiveSession? _activeSession;
  bool _sessionIsLoading = true;
  bool _isLoadingExcercises = true;
  bool _isLoadingAcitve = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await _getActiveSession();
    await _getSession();
    await _getExcercises();
    _setCurrentExcercise();
  }

  void _setCurrentExcercise() {
    setState(() {
      _currentExcercise =
          _excercises?.firstWhere((e) => e.id == _activeSession!.excerciseId);
    });
  }

  Future<void> _getSession() async {
    try {
      setState(() => _sessionIsLoading = true);

      if (_activeSession != null) {
        final sessionResponse = await supabase
            .from('sessions')
            .select()
            .eq('id', _activeSession!.sessionId)
            .single();
        if (sessionResponse.isEmpty) {
          throw const FormatException("Session response empty");
        }

        setState(() => _session = Session.fromMap(sessionResponse));
      }
    } catch (e) {
      logger.e(e);
      if (!mounted) return;
      context.showSnackBar(message: "Error al cargar sesión");
    } finally {
      setState(() => _sessionIsLoading = false);
    }
  }

  Future<void> _getExcercises() async {
    try {
      setState(() => _isLoadingExcercises = true);
      if (_session != null) {
        final excerciseResponse = await supabase.rpc('get_session_excercises',
            params: {
              'p_session_id': _session!.id
            }).order('excercise_order', ascending: true) as List<dynamic>;

        if (excerciseResponse.isEmpty) {
          throw const FormatException("Excercise response empty");
        }

        final data = excerciseResponse
            .map((item) => Excercise.fromMap(item as Map<String, dynamic>))
            .toList();

        setState(() => _excercises = data);
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error al cargar ejercicios");
      }
    } finally {
      setState(() => _isLoadingExcercises = false);
    }
  }

  Future<void> _getActiveSession() async {
    try {
      setState(() => _isLoadingAcitve = true);
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('active_excercise')
          .select()
          .eq('profile_id', userId)
          .limit(1)
          .single();
      if (response.isEmpty) throw const FormatException("Active session empty");
      setState(() => _activeSession = ActiveSession.fromMap(response));
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "No se pudo obtener la sesión activa");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  Future<void> _goNextExcercise() async {
    try {
      if (_currentExcercise!.order < _session!.excerciseCount) {
        setState(() => _isLoadingAcitve = true);
        final userId = supabase.auth.currentUser!.id;
        final nextExcercise = _excercises!
            .firstWhere((e) => e.order == (_currentExcercise!.order + 1));
        await supabase.from('active_excercise').update(
            {"excercise_id": nextExcercise.id}).eq("profile_id", userId);
        setState(() => _currentExcercise = nextExcercise);
      } else {
        await _cancelSession();
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/success", (route) => false);
        }
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error actualizando sesión");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  Future<void> _goPreviousExcercise() async {
    try {
      if (_currentExcercise!.order > 1) {
        setState(() => _isLoadingAcitve = true);
        final userId = supabase.auth.currentUser!.id;
        final previousExcercise = _excercises!
            .firstWhere((e) => e.order == (_currentExcercise!.order - 1));
        await supabase.from('active_excercise').update(
            {"excercise_id": previousExcercise.id}).eq("profile_id", userId);
        setState(() => _currentExcercise = previousExcercise);
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error actualizando sesión");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  Future<void> _restartSession() async {
    try {
      if (_currentExcercise!.order != 1) {
        setState(() => _isLoadingAcitve = true);
        final userId = supabase.auth.currentUser!.id;
        final firstExcercise = _excercises!.first;
        await supabase.from('active_excercise').update(
            {"excercise_id": firstExcercise.id}).eq("profile_id", userId);
        setState(() => _currentExcercise = firstExcercise);
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error actualizando sesión");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  Future<void> _cancelSession() async {
    try {
      setState(() => _isLoadingAcitve = true);
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('active_excercise').delete().eq("profile_id", userId);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error actualizando sesión");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80.0,
        title: const Text("Temporizador"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.redPrimary,
            ],
          )),
          child: _sessionIsLoading || _isLoadingExcercises || _isLoadingAcitve
              ? const Center(child: Text("Cargando..."))
              : _currentExcercise!.isFlexible
                  ? FlexibleTimer(
                      excercise: _currentExcercise!,
                      finishSession: () => _cancelSession(),
                      restartSession: () => _restartSession(),
                      next: () => _goNextExcercise(),
                      previous: () => _goPreviousExcercise(),
                    )
                  : MainTimer(
                      excercise: _currentExcercise!,
                      finishSession: () => _cancelSession(),
                      restartSession: () => _restartSession(),
                      next: () => _goNextExcercise(),
                      previous: () => _goPreviousExcercise(),
                    )),
    );
  }
}
