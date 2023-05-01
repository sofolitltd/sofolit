import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/open_app.dart';
import '../../utils/repo.dart';
import '../splash.dart';
import 'change_password.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }
            if (!snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'No data Found!',
                ),
              );
            }

            var data = snapshot.data!;

            // card
            return ProfileCard(data: data);
          }),
    );
  }
}

// card
class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? size.width * .1 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // info title
              Text(
                'Profile',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),
              const SizedBox(height: 8),

              //
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: data.get('image') == ''
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      data.get('image'),
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(width: 16),

                      //
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // name
                            Text(
                              StringUtils.capitalize(data.get('name'),
                                  allWords: true),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),

                            //todo: edit profile
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //         minimumSize: const Size(150, 45),
                            //       ),
                            //       onPressed: () {
                            //         // Navigator.push(
                            //         //     context,
                            //         //     MaterialPageRoute(
                            //         //         builder: (context) =>
                            //         //             EditProfile(data: data)));
                            //       },
                            //       child: const Text('Edit profile')),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // email
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  subtitle: Text(
                    'Email address',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    data.get('email'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.email_rounded),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //mobile
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  subtitle: Text('Mobile number',
                      style: Theme.of(context).textTheme.bodySmall),
                  title: Text(
                    data.get('mobile'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.call),
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //dev
              Text(
                'Contact',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),

              const SizedBox(height: 8),

              // info
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  title: Text(
                    'Sofol IT',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    'Contact with us',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade50.withOpacity(.5),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/logo/logo_black.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  children: [
                    const Divider(height: 8),
                    //call
                    ListTile(
                      onTap: () {
                        OpenApp.withNumber(AppRepo.kDevMobile);
                      },
                      visualDensity: const VisualDensity(vertical: -4),
                      title: const Text(AppRepo.kDevMobile),
                      subtitle: const Text('call now'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          (Icons.call),
                          color: Colors.green.shade400,
                        ),
                      ),
                    ),

                    const Divider(height: 8),

                    //web
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      onTap: () {
                        OpenApp.withUrl('https://${AppRepo.kDevWebsite}');
                      },
                      title: const Text(AppRepo.kDevWebsite),
                      subtitle: const Text('visit website'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          (Icons.language),
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    const Divider(height: 8),

                    // email
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      onTap: () {
                        //
                        OpenApp.withEmail(AppRepo.kDevEmail);
                      },
                      title: const Text(AppRepo.kDevEmail),
                      subtitle: const Text('email us'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          (Icons.email),
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // account
              Text(
                'Account',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),

              // pass
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()));
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    'Change your old password',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.lock_outline),
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // log out
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  trailing: const Icon(Icons.arrow_right_alt_outlined),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Icon(
                      (Icons.logout_outlined),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Log out',
                    // textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('leave for now'),
                  onTap: () => showAlertDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Future<void> showAlertDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Log out!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure to log out?'),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
              child: const Text('Yes'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Splash()),
                      (route) => false);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
