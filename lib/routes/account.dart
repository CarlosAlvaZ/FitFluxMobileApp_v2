import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late final String userId;

  late final String username;

  late final String email;

  late final String createdAt;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    setState(() {
      userId = supabase.auth.currentUser!.id;
      email = supabase.auth.currentUser!.email ?? "";
      createdAt = supabase.auth.currentUser!.createdAt;
    });
    final response = await supabase
        .from("profiles")
        .select()
        .eq("id", userId)
        .limit(1)
        .single();
    if (response.isNotEmpty && response['username'] != null) {
      setState(() => username = response['username']);
    }
    setState(() => isLoading = false);
  }

  String _buildDate(String date) {
    final parsed = DateTime.parse(date).toLocal();
    final day = parsed.day;
    final month = parsed.month;
    final year = parsed.year;
    final hour = parsed.hour;
    final minute = parsed.minute;
    return "$day del $month, $year. A las $hour:$minute";
  }

  void _logout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: const Text('Cuenta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              // User avatar
              CircleAvatar(
                radius: 54.0,
                backgroundColor: AppColors.redPrimary,
                foregroundImage: NetworkImage(dicebearAPI + userId),
              ),
              const SizedBox(height: 24.0),

              isLoading
                  ? const Skeleton(
                      width: 80,
                      height: 24,
                    )
                  : Text(
                      username,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 8.0),
              isLoading
                  ? const Skeleton(
                      height: 24,
                      width: 100,
                    )
                  : Text(
                      email,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
              const SizedBox(height: 16.0),

              isLoading
                  ? const Skeleton(
                      width: 92,
                      height: 24,
                    )
                  : Text(
                      _buildDate(createdAt),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

