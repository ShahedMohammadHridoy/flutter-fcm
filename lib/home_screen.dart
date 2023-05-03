import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              // send notification from one device to another
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'notification': {
                    'title': 'Shahed',
                    'body': 'Hello, this is the body of notification',
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data': {'type': 'msj', 'id': 'Shahed'}
                };

                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      // Replace the hashes with key from firebase console
                      'Authorization': 'key=######################'
                    }).then((value) {
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace) {
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
            child: const Text('Send Notifications')),
      ),
    );
  }
}
