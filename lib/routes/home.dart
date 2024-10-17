import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/models/session.dart';
import 'package:fit_flux_mobile_app_v2/utils/get_current_day.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/create_new_excercise_modal.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_text_input.dart';
import 'package:fit_flux_mobile_app_v2/widgets/empty_message_sliver.dart';
import 'package:fit_flux_mobile_app_v2/widgets/error_message_sliver.dart';
import 'package:fit_flux_mobile_app_v2/widgets/home_sliver_app_bar.dart';
import 'package:fit_flux_mobile_app_v2/widgets/modal_text_input.dart';
import 'package:fit_flux_mobile_app_v2/widgets/sliver_list_loading.dart';
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

  @override
  void initState() {
    super.initState();
    _getSession();
  }

  Future<void> _getSession() async {
    try {
      final today = GetCurrentDay.weekday();

      final sessionResponse =
          await supabase.from('sessions').select().eq('day', today).single();
      if (sessionResponse.isEmpty) {
        throw const FormatException("Session response empty");
      }

      setState(() => _session = Session.fromMap(sessionResponse));
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar(message: "Error al cargar sesión");
    }
  }

  Future<List<Excercise>?> _getExcercises() async {
    try {
      if (_session == null) return null;

      final excerciseResponse = await supabase.rpc('get_session_excercises',
          params: {'p_session_id': _session!.id}).order('excercise_order');

      if (excerciseResponse.isEmpty) return List.empty();

      setState(() => _excercises =
          excerciseResponse.map((item) => Excercise.fromMap(item)).toList());
    } catch (e) {
      if (!mounted) return null;
      context.showSnackBar(message: "Error al cargar sesión");
    }
    return _excercises;
  }

  void _showCreateNewExcerciseModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return const CreateNewExcerciseModal();
        });
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
          FutureBuilder(
              future: _getExcercises(),
              builder: (context, snapShot) {
                if (snapShot.hasError) return const ErrorMessageSliver();

                if (snapShot.data != null && snapShot.data!.isEmpty) {
                  return const EmptyMessageSliver();
                }

                if (snapShot.data != null && snapShot.data!.isNotEmpty) {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {}));
                }

                return const SliverListLoading();
              })
        ],
      ),
    );
  }
}
