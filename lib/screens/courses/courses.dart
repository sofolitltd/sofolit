import 'package:flutter/material.dart';
import 'package:sofolit/admin/admin_button.dart';
import 'package:sofolit/utils/send_mail.dart';

import '/screens/courses/widgets/my_courses.dart';

class Courses extends StatelessWidget {
  const Courses({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      // todo
      floatingActionButton: AdminButton(
        onPressed: () async {
          //     var recipientToken = await FirebaseMessaging.instance.getToken();
          //     // print(recipientToken.toString());
          //     await sendPushMessage(
          //         recipientToken: 'topic', title: 'title', body: 'body text');

          //
          await sendEmail(context);
        },
      ),
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(
            horizontal: !isSmallScreen ? size.width * .1 : 0),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              //recent
              // RecentSection(),

              //my courses
              MyCourses(),
            ],
          ),
        ),
      ),
    );
  }
}
