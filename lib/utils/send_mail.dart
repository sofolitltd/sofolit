import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:sofolit/utils/credentials.dart';

sendEmail(BuildContext context //For showing snackbar
    ) async {
  String username = Credentials.email; //Your Email
  String password = Credentials.password;

  //
  final smtpServer = gmail(username, password);

  // Create our message.
  final message = Message()
        ..from = Address(username, 'Sofol IT')
        ..recipients.add('asifreyad1@gmail.com')
        // ..ccRecipients.addAll(['abc@gmail.com', 'xyz@gmail.com']) // For Adding Multiple Recipients
        // ..bccRecipients.add(Address('a@gmail.com')) For Binding Carbon Copy of Sent Email
        ..subject = 'Mail from Mailer'
        ..text = 'Hello dear, I am sending you email from Flutter application'
      // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"; // For Adding Html in email
      // ..attachments = [
      //   FileAttachment(File('image.png'))  //For Adding Attachments
      //     ..location = Location.inline
      //     ..cid = '<myimg@3.141>'
      // ]
      ;

  //
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Mail Send Successfully")));
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e.message);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
