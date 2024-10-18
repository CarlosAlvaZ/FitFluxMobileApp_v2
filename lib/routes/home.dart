import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/models/session.dart';
import 'package:fit_flux_mobile_app_v2/utils/get_current_day.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/create_new_excercise_modal.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_button.dart';
import 'package:fit_flux_mobile_app_v2/widgets/empty_message_sliver.dart';
import 'package:fit_flux_mobile_app_v2/widgets/error_message_sliver.dart';
import 'package:fit_flux_mobile_app_v2/widgets/excercise_list_item.dart';
import 'package:fit_flux_mobile_app_v2/widgets/home_sliver_app_bar.dart';
import 'package:fit_flux_mobile_app_v2/widgets/sliver_list_loading.dart';
import 'package:fit_flux_mobile_app_v2/utils/logger.dart' show logger;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Excercise> _excercises = [];
  Session? _session;
  bool _isLoading = true;
  bool _isLoadingExcercises = true;
  bool _excercisesHaveError = false;
  bool _isLoadingAcitve = true;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _getSession();
    await _getExcercises();
    await _getActiveSession();
  }

  Future<void> _getSession() async {
    try {
      setState(() => _isLoading = true);

      final today = GetCurrentDay.weekday();

      final sessionResponse =
          await supabase.from('sessions').select().eq('day', today).single();
      if (sessionResponse.isEmpty) {
        throw const FormatException("Session response empty");
      }

      setState(() => _session = Session.fromMap(sessionResponse));
    } catch (e) {
      logger.e(e);
      if (!mounted) return;
      context.showSnackBar(message: "Error al cargar sesión");
    } finally {
      setState(() => _isLoading = false);
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

        if (excerciseResponse.isEmpty) return;

        final data = excerciseResponse
            .map((item) => Excercise.fromMap(item as Map<String, dynamic>))
            .toList();

        setState(() => _excercises = data);
      }
    } catch (e) {
      logger.e(e);
      setState(() => _excercisesHaveError = true);
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
      final active = await supabase
          .from('active_excercise')
          .select()
          .eq('profile_id', userId);
      if (active.isEmpty) {
        setState(() => _isActive = false);
      } else {
        setState(() => _isActive = true);
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "No se pudo obtener la sesión activa");
      }
    } finally {
      setState(() => _isLoadingAcitve = false);
    }
  }

  Future<void> _removeExcercise(String id) async {
    try {
      await supabase.rpc('remove_excercise', params: {'p_excercise_id': id});
      if (mounted) {
        context.showSnackBar(message: "Actividad eliminada exitosamente");
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error al eliminar actividad");
      }
    }
  }

  void _showCreateNewExcerciseModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CreateNewExcerciseModal(
              onSubmit: _createNewExcercise,
            ));
  }

  void _showEditExcerciseModal(BuildContext context, Excercise excercise) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CreateNewExcerciseModal(
              onSubmit: _updateExcercise,
              excercise: excercise,
              buttonText: "Actualizar",
            ));
  }

  void _onDismissed(String id) {
    setState(() => _excercises.removeWhere((e) => e.id == id));
    _removeExcercise(id);
  }

  Future<void> _startSession() async {
    try {
      if (_session == null || supabase.auth.currentUser == null) return;
      final userId = supabase.auth.currentUser!.id;
      await supabase.rpc('start_session',
          params: {'p_profile_id': userId, 'p_session_id': _session!.id});
      await _getActiveSession();
      if (mounted) {
        Navigator.of(context).pushNamed('/timer');
      }
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error al eliminar actividad");
      }
    }
  }

  Future<void> _createNewExcercise(Excercise excercise) async {
    if (_session == null) return;
    try {
      await supabase.rpc('create_new_excercise', params: {
        'p_session_id': _session!.id,
        'p_name': excercise.name,
        'p_description': excercise.description,
        'p_duration': excercise.isFlexible ? 0 : excercise.duration,
        'p_is_flexible': excercise.isFlexible
      });
      _getExcercises();
    } catch (e) {
      logger.e(e);
      if (!mounted) return;
      context.showSnackBar(message: "Ha ocurrido un error. Intente más tarde.");
    }
  }

  Future<void> _updateExcercise(Excercise excercise) async {
    try {
      await supabase.from('excercises').update({
        "name": excercise.name,
        "description": excercise.description,
        "is_flexible": excercise.isFlexible,
        "duration": excercise.duration
      }).eq("id", excercise.id);
      _getExcercises();
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "No se pudo actualizar el ejercicio");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.extraPrimary,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => _showCreateNewExcerciseModal(context),
          label: const Row(
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 8.0,
              ),
              Text("Añadir ejercicio"),
            ],
          )),
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(),
          _isLoading || _isLoadingExcercises
              ? const SliverListLoading()
              : _excercisesHaveError
                  ? const ErrorMessageSliver()
                  : _excercises.isEmpty
                      ? const EmptyMessageSliver()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              childCount: _excercises.length,
                              (context, index) => ExcerciseListItem(
                                    onTap: () => _showEditExcerciseModal(
                                        context, _excercises[index]),
                                    onDismissed: (_) =>
                                        _onDismissed(_excercises[index].id),
                                    exercise: _excercises[index],
                                  ))),
          _excercises.isNotEmpty
              ? SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverToBoxAdapter(
                    child: CustomButton(
                        text: _isLoadingAcitve
                            ? "Cargando..."
                            : _isActive
                                ? "Ir a sesión activa"
                                : "Iniciar",
                        onPressed: _isLoadingAcitve
                            ? null
                            : _isActive
                                ? () async {
                                    await Navigator.of(context)
                                        .pushNamed('/timer');
                                    _getActiveSession();
                                  }
                                : _startSession),
                  ),
                )
              : const SliverToBoxAdapter()
        ],
      ),
    );
  }
}
