import 'package:fitness_app/core/error/exception.dart';
import 'package:fitness_app/features/home_screen/data/models/other_tracker_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class GetOtherTracker {
  Future<List<OtherTracker>> getOtherTracker();
}

class GetOtherTrackerImpl implements GetOtherTracker {
  final SupabaseClient _supabaseClient;

  GetOtherTrackerImpl(this._supabaseClient);

  DateTime formattedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime parseDate(String dateString) {
    return DateTime.parse(dateString);
  }

  @override
  Future<List<OtherTracker>> getOtherTracker() async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;

      List<DateTime> last30Days = List.generate(
        30,
        (index) => DateTime.now().subtract(Duration(days: 29 - index)),
      );

      List<OtherTracker> res = [];

      for (final date in last30Days) {
        final data =
            await _supabaseClient
                .from('other_tracker')
                .select()
                .eq('user_id', userId)
                .eq('date', formattedDate(date)) // <- should return DateTime
                .maybeSingle();

        // if (data?['sleep_time_start'] != null)
        //   print(
        //     'sleep Time start ${parseDate(data?['sleep_time_start'])} ${parseDate(data?['sleep_time_end'])}',
        //   );
        res.add(
          OtherTracker(
            waterTracker: data?['water_intake'].toDouble() ?? 0,
            sleepTracker: data?['sleep_hours'].toDouble() ?? 0,
            stepsTracker: data?['steps'].toDouble() ?? 0,
            sleepStartTime:
                data?['sleep_time_start'] != null
                    ? parseDate(data?['sleep_time_start'])
                    : null,
            sleepEndTime:
                data?['sleep_time_end'] != null
                    ? parseDate(data?['sleep_time_end'])
                    : null,
          ),
        );
      }
      return res;
    } catch (e) {
      print('error Message: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }
}
