import 'dart:convert';
import 'dart:developer' as devtools show log;

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

//
Future<bool> sendPushMessage({
  required String recipientToken,
  required String title,
  required String body,
}) async {
  //
  final jsonCredentials = await rootBundle
      .loadString('data/sofolitbd-firebase-adminsdk-a9t0o-bd8b06f57d.json');
  final credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  //
  final client = await auth.clientViaServiceAccount(
    credentials,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );

  //
  final notificationData = {
    'message': {
      // 'token': recipientToken,
      'notification': {'title': title, 'body': body},
      'data': {'noticeID': '1'},
      'topic': 'topic',
    },
  };

  //change as your project id
  const String senderId = 'sofolitbd';
  final response = await client.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
    headers: {
      'content-type': 'application/json',
    },
    body: jsonEncode(notificationData),
  );

  client.close();
  if (response.statusCode == 200) {
    devtools.log('Notification Response code: ${response.statusCode}');

    return true; // Success!
  }

  devtools.log(
      'Notification Sending Error Response status: ${response.statusCode}');
  devtools.log('Notification Response body: ${response.body}');
  return false;
}
