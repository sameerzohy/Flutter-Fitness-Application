import 'package:fitness_app/core/theme/appPalatte.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateScroller extends StatefulWidget {
  @override
  _DateScrollerState createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  int selectedIndex = 29; // Today (latest date)

  List<DateTime> last30Days = List.generate(
    30,
    (index) => DateTime.now().subtract(Duration(days: 29 - index)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: last30Days.length,
        itemBuilder: (context, index) {
          final date = last30Days[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient:
                    isSelected
                        ? LinearGradient(
                          colors: [AppPallete.gradient1, AppPallete.gradient2],
                        )
                        : null,
                color: isSelected ? null : Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date), // e.g., Mon, Tue
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
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
    );
  }
}
