import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static String _getLocalTimezone() {
    try {
      final DateTime now = DateTime.now();
      final Duration offset = now.timeZoneOffset;

      // Common timezone mappings based on offset
      final int offsetHours = offset.inHours;

      switch (offsetHours) {
        case -12:
          return 'Pacific/Kwajalein';
        case -11:
          return 'Pacific/Samoa';
        case -10:
          return 'Pacific/Honolulu';
        case -9:
          return 'America/Anchorage';
        case -8:
          return 'America/Los_Angeles';
        case -7:
          return 'America/Denver';
        case -6:
          return 'America/Chicago';
        case -5:
          return 'America/New_York';
        case -4:
          return 'America/Halifax';
        case -3:
          return 'America/Sao_Paulo';
        case -2:
          return 'Atlantic/South_Georgia';
        case -1:
          return 'Atlantic/Azores';
        case 0:
          return 'Europe/London';
        case 1:
          return 'Europe/Paris';
        case 2:
          return 'Europe/Berlin';
        case 3:
          return 'Europe/Moscow';
        case 4:
          return 'Asia/Dubai';
        case 5:
          return 'Asia/Kolkata'; // India Standard Time
        case 5.5:
          return 'Asia/Karachi';
        case 6:
          return 'Asia/Dhaka';
        case 7:
          return 'Asia/Bangkok';
        case 8:
          return 'Asia/Shanghai';
        case 9:
          return 'Asia/Tokyo';
        case 10:
          return 'Australia/Sydney';
        case 11:
          return 'Pacific/Noumea';
        case 12:
          return 'Pacific/Fiji';
        default:
          return 'UTC';
      }
    } catch (e) {
      print('Error determining timezone: $e');
      return 'UTC';
    }
  }

  /// Initialize the notification service
  static Future<void> initializeNotifications() async {
    if (_isInitialized) {
      return;
    }

    try {
      // 1. Initialize timezone
      tz.initializeTimeZones();
      String timeZoneName = _getLocalTimezone();
      print('TimeZoneName $timeZoneName');
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      // 2. Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // 3. iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // 4. Combined initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 5. Initialize the plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      print('Notifications initialized successfully');
    } catch (e) {
      print('Error initializing notifications: $e');
      rethrow;
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('Notification tapped with payload: $payload');
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        // Request notification permission for Android 13+
        final bool? granted =
            await androidImplementation?.requestNotificationsPermission();

        // Request exact alarm permission for Android 12+
        await androidImplementation?.requestExactAlarmsPermission();

        return granted ?? false;
      }

      if (Platform.isIOS) {
        final IOSFlutterLocalNotificationsPlugin? iosImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >();

        final bool? granted = await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        return granted ?? false;
      }

      return true;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS handles this differently
  }

  /// Schedule a meal reminder notification
  static Future<void> scheduleMealReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meal_channel',
            'Meal Reminders',
            channelDescription: 'Reminders for your daily meals',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'meal_notification_$id',
      );

      print(
        'Scheduled notification: $title at $hour:${minute.toString().padLeft(2, '0')}',
      );
    } catch (e) {
      print('Error scheduling meal reminder: $e');
      rethrow;
    }
  }

  /// Calculate the next instance of the specified time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Schedule all meal notifications
  static Future<void> scheduleAllMealNotifications() async {
    try {
      // Cancel any existing notifications first
      await cancelAllNotifications();

      await scheduleMealReminder(
        id: 1,
        title: "Breakfast Time! 🌅",
        body: "Don't skip breakfast! Start your day with a healthy meal.",
        hour: 8,
        minute: 0,
      );

      await scheduleMealReminder(
        id: 2,
        title: "Morning Snack 🍎",
        body: "Time for your healthy morning snack!",
        hour: 10,
        minute: 0,
      );

      await scheduleMealReminder(
        id: 3,
        title: "Lunch Time! 🍽️",
        body: "Take a break and enjoy your lunch!",
        hour: 13,
        minute: 0,
      );

      await scheduleMealReminder(
        id: 4,
        title: "Evening Snack 🥜",
        body: "Grab a light and healthy snack.",
        hour: 18,
        minute: 29,
      );

      await scheduleMealReminder(
        id: 5,
        title: "Dinner Time! 🌙",
        body: "End your day with a nutritious dinner!",
        hour: 19,
        minute: 30,
      );

      print('All meal notifications scheduled successfully');
    } catch (e) {
      print('Error scheduling meal notifications: $e');
      rethrow;
    }
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print('Cancelled notification with id: $id');
    } catch (e) {
      print('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('All notifications cancelled');
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
    } catch (e) {
      print('Error getting pending notifications: $e');
      return [];
    }
  }

  /// Complete setup process
  static Future<bool> setupNotifications() async {
    try {
      await initializeNotifications();

      final bool permissionGranted = await requestPermissions();

      if (!permissionGranted) {
        print('Notification permissions not granted');
        return false;
      }

      final bool notificationsEnabled = await areNotificationsEnabled();

      if (!notificationsEnabled) {
        print('Notifications are not enabled');
        return false;
      }

      await scheduleAllMealNotifications();

      print('Notification setup completed successfully');
      return true;
    } catch (e) {
      print('Error setting up notifications: $e');
      return false;
    }
  }
}
