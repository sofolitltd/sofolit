import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/course_model.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    int remainingDays = course.enrollEnd.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        //
        context.go('/courses/${course.slug}',
            extra: course.title); // Navigate using slug
      },
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black12,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 315,
          height: 315,
          child: Column(
            children: [
              //
              Stack(
                alignment: Alignment.topRight,
                children: [
                  //image
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        topRight: Radius.circular(9),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          course.imageUrls,
                        ),
                      ),
                      color: Colors.blueAccent.shade100.withValues(alpha: .05),
                    ),
                  ),

                  //
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${course.discount}% ',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'off',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              //sub and tile
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //sub and title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text(
                            course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  height: 1.2,
                                  // fontSize: 18,
                                ),
                          ),
                        ],
                      ),

                      // price & seat
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //price
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //price
                                Text(
                                  '৳ ${course.price - (course.price * (course.discount / 100)).round()}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                ),
                                const SizedBox(width: 8),

                                //discount
                                Text(
                                  '৳ ${course.price} ',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        // fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        height: 1.3,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                              ],
                            ),

                            //seat
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     const Icon(
                            //       Icons.people_outline,
                            //       size: 20,
                            //     ),
                            //
                            //     const SizedBox(width: 8),
                            //     //
                            //     Text(
                            //       '${course.seats - course.seats} seats left',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .titleMedium!
                            //           .copyWith(),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //batch
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black12.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                course.batch,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        // fontWeight: FontWeight.w500,
                                        ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            //remaining
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.watch_later_outlined,
                                  size: 14,
                                  color: Colors.black54,
                                ),

                                const SizedBox(width: 4),
                                //
                                Text(
                                  remainingDays <= 0
                                      ? 'On Going'
                                      : '$remainingDays days left',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: remainingDays == 0
                                            ? Colors.red
                                            : null,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
