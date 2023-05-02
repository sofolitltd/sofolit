import 'package:flutter/material.dart';

import '/screens/home/widgets/home_courses.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: !isSmallScreen
            ? const Text('Home')
            : Image.asset(
                'assets/logo/logo_black.png',
                height: 40,
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: !isSmallScreen ? size.width * .1 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              Container(
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    //
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Free Career Guideline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),

                              //
                              Expanded(child: Container())
                            ],
                          ),

                          //
                          Text(
                            '~ Free video, Expert Guideline, Blog',
                            style: TextStyle(
                              color: Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                        ),
                      ),
                    ),

                    //
                    Positioned(
                      top: -8,
                      right: -8,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                      ),
                    ),

                    //
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Icon(
                        Icons.touch_app_outlined,
                        size: 32,
                        color: Colors.orange.shade300,
                      ),
                    ),
                  ],
                ),
              ),

              //
              const HomeCourses(),
            ],
          ),
        ),
      ),
    );
  }
}
