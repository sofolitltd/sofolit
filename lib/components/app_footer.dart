import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_icons/icon_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        return Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1300),
              color: Colors.grey.shade200, // Customize background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Layout based on screen size
                  if (maxWidth > 800)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'সফল আইটি',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'আপনাকে স্বাগতম! আমাদের প্ল্যাটফর্মে যেকোনো বয়সের শিক্ষার্থী, পেশাদার এবং ফ্রিল্যান্সারদের জন্য দক্ষতা উন্নয়নের সুযোগ রয়েছে।আপনার স্বপ্নের ক্যারিয়ার শুরু করুন এখনই!',
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavigationLinks(context),
                              _buildSocialIcons(),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    // Mobile/Tablets - Single Column Layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'সফল আইটি',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'আপনাকে স্বাগতম! আমাদের প্ল্যাটফর্মে যেকোনো বয়সের শিক্ষার্থী, পেশাদার এবং ফ্রিল্যান্সারদের জন্য দক্ষতা উন্নয়নের সুযোগ রয়েছে।আপনার স্বপ্নের ক্যারিয়ার শুরু করুন এখনই!',
                        ),
                        const SizedBox(height: 32),
                        _buildNavigationLinks(context),
                        const SizedBox(height: 32),
                        _buildSocialIcons(),
                      ],
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 40,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  // Footer section for copyright and logo

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: Image.asset(
                          'assets/images/logo_black.png',
                          height: 40,
                        ),
                      ), // Placeholder for logo
                      Text(
                        'Copyright © ${DateTime.now().year} Sofol IT',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        const Text(
          'নেভিগেশন',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 16),
        //
        Wrap(
          // direction: Axis.vertical,
          spacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {
                if (GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .uri
                        .toString() !=
                    '/') {
                  context.go('/');
                }
              },
              child: const Text(
                'হোম',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            //
            OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: () {
                if (GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .uri
                        .toString() !=
                    '/courses') {
                  context.go('/courses');
                }
              },
              child: const Text(
                'কোর্স সমূহ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        const Text(
          'সোশ্যাল লিঙ্ক',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        const SizedBox(height: 16),

        //
        Wrap(
          spacing: 0,
          children: [
            IconButton(
              onPressed: () {
                // url luncher
                launchUrl(Uri.parse('https://www.facebook.com/sofolitltd'));
              },
              icon: const Icon(Icons.facebook),
            ),
            IconButton(
              onPressed: () {
                launchUrl(Uri.parse('https://www.youtube.com/@sofolitltd'));
              },
              icon: IconIcons.youtube(
                height: 24.0,
                width: 24.0,
              ),
            ),
            IconButton(
              onPressed: () {
                launchUrl(
                    Uri.parse('https://www.linkedin.com/company/sofolitltd'));
              },
              icon: IconIcons.linkedin(
                height: 24.0,
                width: 24.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
