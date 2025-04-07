import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/login.dart';
import '../bkash/bkash_gateway.dart';
import '../components/app_footer.dart';
import '../db/controllers/course_controller.dart';
import '../model/course_model.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String slug;

  const CourseDetailsScreen({super.key, required this.slug});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isLoading = false;
  final CourseController courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    courseController.fetchCourseBySlug(widget.slug);

    return Scaffold(
      body:
          isLoading
              ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Redirecting to payment gateway,\nPlease wait...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    //
                    Obx(() {
                      if (courseController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final course = courseController.selectedCourse.value;

                      if (course == null) {
                        return const Center(child: Text('Course not found'));
                      }

                      return Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1300),
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16.0,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 800) {
                                // Mobile layout
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildCourseImageBox(course),
                                      const SizedBox(height: 32),
                                      _buildCourseDetailsBox(course),
                                    ],
                                  ),
                                );
                              } else {
                                // Desktop layout
                                return SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height - 100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildCourseImageBox(course),
                                            const SizedBox(height: 32),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        flex: 2,
                                        child: _buildCourseDetailsBox(course),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }),

                    //
                    ...[const SizedBox(height: 40), const AppFooter()],
                  ],
                ),
              ),
    );
  }

  _buildCourseImageBox(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(course.imageUrls, fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        Text(
          course.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(course.description),
      ],
    );

    //
  }

  //
  Widget _buildCourseDetailsBox(Course course) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'এই কোর্সের ভেতরে যা যা রয়েছে',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                [
                  '১০০+ ঘণ্টার রেকর্ডেড ভিডিও',
                  'বেসিক থেকে অ্যাডভান্সড লেভেল',
                  'কুইজ',
                  '৬ মাসের ব্যাচ / ২ বছরের কন্টেন্ট অ্যাক্সেস',
                ].map((item) {
                  return Text('✦ $item');
                }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            children: [
              const Text(
                'কোর্সের মূল্য:',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                ' ৳${course.price} ',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '৳ ${course.price - (course.price * (course.discount / 100)).round()}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  setState(() {
                    isLoading = true;
                  });
                  _startBkashPayment(
                    slug: widget.slug,
                    amount:
                        (course.price -
                                (course.price * (course.discount / 100))
                                    .round())
                            .toString(),
                  );
                } else {
                  showLoginDialog(context);
                }
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ভর্তি হোন এখনই',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //
  Future<void> _startBkashPayment({
    required String slug,
    required String amount,
  }) async {
    try {
      var grantTokenResponse =
          await BkashPaymentGateway(isProduction: false).grantToken();

      var createPaymentResponse = await BkashPaymentGateway(
        isProduction: false,
      ).createPayment(
        idToken: grantTokenResponse.idToken,
        amount: amount,
        invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
        slug: slug,
      );

      var paymentUrl = createPaymentResponse.bkashURL;

      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(Uri.parse(paymentUrl), webOnlyWindowName: '_self');
      } else {
        Fluttertoast.showToast(msg: 'Payment gateway URL Error');
        print('Payment gateway Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment gateway Error $e');
      print('Error: $e');
    }
  }
}
