import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofolit/auth/login.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Full width white background
        border: Border(bottom: BorderSide(color: Colors.grey[400]!, width: .5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        // This will center the content and limit the width
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1280,
          ), // Content limited to 1300px
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                // Web Navbar
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .uri
                                .toString() !=
                            '/') {
                          context.go('/');
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        child: Image.asset('assets/images/logo_black.png'),
                      ),
                    ), // Logo Placeholder
                    const SizedBox(width: 16),

                    const Spacer(),
                    //
                    Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          if (GoRouter.of(context)
                                  .routerDelegate
                                  .currentConfiguration
                                  .uri
                                  .toString() !=
                              '/courses') {
                            context.go('/courses');
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.black12.withValues(alpha: .05),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'কোর্স সমূহ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    //
                    LoginButton(),
                  ],
                );
              } else {
                // Mobile Navbar
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Builder(
                      builder:
                          (context) => IconButton.outlined(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                    ),

                    //
                    GestureDetector(
                      onTap: () {
                        if (GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .uri
                                .toString() !=
                            '/') {
                          context.go('/');
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        child: Image.asset('assets/images/logo_black.png'),
                      ),
                    ),

                    //
                    LoginButton(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

//

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // Firebase auth state stream
      builder: (context, snapshot) {
        // snapshot.data will be the user object or null if not signed in
        User? user = snapshot.data;

        return Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              if (user == null) {
                showLoginDialog(context); // Show login dialog if not logged in
              } else {
                // Navigate to the dashboard if logged in
                context.go('/dashboard');
              }
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    user == null
                        ? Colors.black12.withValues(alpha: 0.05)
                        : Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                user == null ? 'লগ ইন' : 'ড্যাশবোর্ড',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: user == null ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
