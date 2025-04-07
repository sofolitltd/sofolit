import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/images/logo_black.png',
                      height: 32,
                    ),
                  ),

                  //
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const Divider(
                height: 8,
                thickness: .5,
              ),

              //
              const SizedBox(height: 16),

              //
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('হোম'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
                onTap: () {
                  if (GoRouter.of(context)
                          .routerDelegate
                          .currentConfiguration
                          .uri
                          .toString() !=
                      '/') {
                    context.go('/');
                  }
                  Navigator.pop(context);
                },
              ),

              //
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('কোর্স সমূহ'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
                onTap: () {
                  if (GoRouter.of(context)
                          .routerDelegate
                          .currentConfiguration
                          .uri
                          .toString() !=
                      '/courses') {
                    context.go('/courses');
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
