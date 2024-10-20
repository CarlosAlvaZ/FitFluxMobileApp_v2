import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/utils/get_current_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 80.0,
      centerTitle: true,
      title: Text(
        GetCurrentDay.matchDayWithWeekdaySpanish(
          GetCurrentDay.weekday(),
        ),
        style: context.textTheme.bodyLarge,
      ),
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SvgPicture.asset(
          'assets/f.svg',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/account'),
          child: CircleAvatar(
            minRadius: 24.0,
            backgroundColor: AppColors.redPrimary,
            foregroundImage:
                NetworkImage(dicebearAPI + supabase.auth.currentUser!.id),
          ),
        ),
        const SizedBox(
          width: 24,
        )
      ],
    );
  }
}
