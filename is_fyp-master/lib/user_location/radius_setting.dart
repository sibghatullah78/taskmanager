import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Initialize Flutter Local Notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Initialize Geolocator
Geolocator geolocator = Geolocator();

// Function to set up geofence and reminder
void setUpGeofenceAndReminder(LatLng eventLocation, double radius) {
  GeofenceNotification.triggerWithGeofence(
    GeofenceRegion(
      'event_geofence',
      eventLocation.latitude,
      eventLocation.longitude,
      radius,
      triggersOnce: false,
    ),
    onEntry: (Geofence geofence) {
      // Handle user entering the geofence (optional)
    },
    onExit: (Geofence geofence) {
      // Handle user leaving the geofence
      showReminderNotification();
    },
  );
}

// Function to show reminder notification
void showReminderNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'reminder_channel_id',
    'Reminder Channel',
    'Channel for event reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Event Reminder',
    'You are leaving the event radius.',
    platformChannelSpecifics,
  );
}
