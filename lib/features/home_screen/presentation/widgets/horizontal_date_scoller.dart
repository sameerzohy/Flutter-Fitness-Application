import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/date_selector_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateScroller extends StatefulWidget {
  const DateScroller({super.key});
  @override
  State<DateScroller> createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  final int visibleItemCount = 4;
  late List<DateTime> last30Days;
  int startIndex = 26; // So the last 4 (26-29) are visible by default
  int selectedIndex = 29; // Default selected = today

  @override
  void initState() {
    super.initState();

    last30Days = List.generate(
      30,
      (index) => DateTime.now().subtract(Duration(days: 29 - index)),
    );

    selectedIndex = last30Days.indexWhere(
      (date) =>
          date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day,
    );

    startIndex = (selectedIndex - visibleItemCount + 1).clamp(
      0,
      last30Days.length - visibleItemCount,
    );
  }

  void _goToPreviousGroup() {
    setState(() {
      startIndex = (startIndex - visibleItemCount).clamp(
        0,
        last30Days.length - visibleItemCount,
      );
    });
  }

  void _goToNextGroup() {
    setState(() {
      startIndex = (startIndex + visibleItemCount).clamp(
        0,
        last30Days.length - visibleItemCount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleDates = last30Days.sublist(
      startIndex,
      startIndex + visibleItemCount,
    );

    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: startIndex == 0 ? null : _goToPreviousGroup,
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // disable swipe
              scrollDirection: Axis.horizontal,
              itemCount: visibleDates.length,
              itemBuilder: (context, index) {
                final actualIndex = startIndex + index;
                final date = visibleDates[index];
                final isSelected = actualIndex == selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = actualIndex;
                      context.read<DateSelectorCubit>().setDate(date);
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [
                                  AppPallete.gradient1,
                                  AppPallete.gradient2,
                                ],
                              )
                              : null,
                      color: isSelected ? null : Colors.grey[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed:
                startIndex + visibleItemCount >= last30Days.length
                    ? null
                    : _goToNextGroup,
          ),
        ],
      ),
    );
  }
}
