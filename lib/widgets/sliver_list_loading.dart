import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/widgets/skeleton.dart';
import 'package:flutter/material.dart';

class SliverListLoading extends StatelessWidget {
  const SliverListLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: 8,
            (context, i) => const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton(
                          height: 16.0,
                          width: 180.0,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Skeleton(
                          height: 16.0,
                          width: 150.0,
                        ),
                      ],
                    ),
                    tileColor: AppColors.extraQuaternary,
                  ),
                )));
  }
}
