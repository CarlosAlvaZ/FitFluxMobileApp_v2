import 'dart:math';

import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/models/session.dart';
import 'package:fit_flux_mobile_app_v2/utils/get_current_day.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/create_new_excercise_modal.dart';
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
  Future<List<Excercise>>? _excercisesFuture;
  Session? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getSession();
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

      _loadExcercises();
    } catch (e) {
      logger.e(e);
      if (!mounted) return;
      // context.showSnackBar(message: "Error al cargar sesión");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Excercise>> _getExcercises() async {
    try {
      if (_session != null) {
        final excerciseResponse = await supabase.rpc('get_session_excercises',
            params: {
              'p_session_id': _session!.id
            }).order('excercise_order', ascending: true) as List<dynamic>;

        if (excerciseResponse.isEmpty) return [];

        return excerciseResponse
            .map((item) => Excercise.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      logger.e(e);
      if (mounted) {
        context.showSnackBar(message: "Error al cargar ejercicios");
      }
      return [];
    }
  }

  void _loadExcercises() {
    if (mounted) {
      setState(() => _excercisesFuture = _getExcercises());
    }
  }

  void _showCreateNewExcerciseModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CreateNewExcerciseModal(
            onSubmit: _createNewExcercise,
          );
        });
  }

  Future<void> _createNewExcercise(
      String name, String description, bool isFlexible, int duration) async {
    if (_session == null) return;
    try {
      await supabase.rpc('create_new_excercise', params: {
        'p_session_id': _session!.id,
        'p_name': name,
        'p_description': description,
        'p_duration': isFlexible ? 0 : duration,
        'p_is_flexible': isFlexible
      });
      _loadExcercises();
    } catch (e) {
      logger.e(e);
      if (!mounted) return;
      context.showSnackBar(message: "Ha ocurrido un error. Intente más tarde.");
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
          _isLoading
              ? const SliverListLoading()
              : FutureBuilder<List<Excercise>>(
                  future: _excercisesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverListLoading(); // Show loading while the future is running
                    } else if (snapshot.hasError) {
                      return const ErrorMessageSliver(); // Show error message if there was an error
                    } else if (snapshot.hasData) {
                      final excercises = snapshot.data!;

                      if (excercises.isEmpty) {
                        return const EmptyMessageSliver();
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              ExcerciseListItem(exercise: excercises[index]),
                          childCount: excercises.length,
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(
                      child: Text("Unknown state"),
                    );
                  },
                )
        ],
      ),
    );
  }
}
