import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';

class WorkoutCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final VoidCallback? onTap; // navigation only on "View more"

  const WorkoutCategoryCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.greycard1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Text Part
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(fontSize: 14, color: AppPallete.greycard1)),
                const SizedBox(height: 6),
                
                // Only "View more" is tappable
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    "View more",
                    style: TextStyle(fontSize: 14, color: AppPallete.trackerContainerBackground1),
                  ),
                ),
              ],
            ),
          ),

          // Image with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.gradient1,
                  AppPallete.gradient2,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              imgPath,
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
