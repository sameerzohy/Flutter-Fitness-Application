import 'package:fitness_app/core/entities/exercise_entity.dart';
import 'package:fitness_app/core/theme/appPalatte.dart';

import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final ExerciseEntity data;
  final VoidCallback? onTap; // Optional navigation

  const ExerciseTile({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppPallete.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                data.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              data.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              data.name,
              style: TextStyle(
                fontSize: 14,
                color: AppPallete.gray2,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppPallete.gray2,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
