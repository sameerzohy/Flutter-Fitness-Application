import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  final String title;
  final String time;
  final String imgPath;

  const WorkoutTile({
    Key? key,
    required this.title,
    required this.time,
    required this.imgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppPallete.greycard1,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(imgPath),
            backgroundColor: AppPallete.whiteColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
