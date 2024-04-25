import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../model/course_model.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  bool _isProgress = false;

  // Buying date range
  DateTime? _enrollStart;
  DateTime? _enrollFinish;

  // Start date
  DateTime? _classStartDate;

  // Class day and time
  final List<String> _classSchedule = [];

  //
  String? _selectedDay;

  @override
  void dispose() {
    super.dispose();
  }

  // range
  _pickDateRangeDialog() async {
    final pickedDateRange = await showDateRangePicker(
      context: context,
      barrierColor: Colors.red,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      useRootNavigator: false,
      // Use false to avoid fullscreen dialog
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
            dialogBackgroundColor: Theme.of(context).dividerTheme.color,
            appBarTheme: Theme.of(context).appBarTheme,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                onPrimary: Theme.of(context).primaryColorLight,
                primary: Theme.of(context).colorScheme.primary)),
        child: child!,
      ),
    );

    if (pickedDateRange == null) return;

    // Validate the picked date range
    if (pickedDateRange.start.isBefore(pickedDateRange.end)) {
      setState(() {
        _enrollStart = pickedDateRange.start;
        _enrollFinish = pickedDateRange.end;
      });
    } else {
      Fluttertoast.showToast(
        msg: "End date should be after start date",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

// Date and time
  _pickClassStartDateTime() async {
    // Pick date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 22, minute: 00),
    );

    if (pickedTime == null) return;

    // Combine date and time
    final pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Validate the class start date against the enroll finish date
    if (_enrollFinish != null && pickedDateTime.isAfter(_enrollFinish!)) {
      setState(() {
        _classStartDate = pickedDateTime;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Class start date should be after enroll finish date",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Method for selecting class day and time
  _pickClassSchedule() async {
    // Day
    final selectedDay = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Day'),
        content: DropdownButtonFormField<String>(
          value: _selectedDay,
          hint: const Text('Week day'),
          items: [
            'Saturday',
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
          ]
              .map<DropdownMenuItem<String>>(
                (day) => DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedDay = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedDay);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Start time
    if (selectedDay != null) {
      final startTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 22, minute: 00),
        confirmText: "Set Start Time  ",
      );

      // End time
      if (startTime != null) {
        final endTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 23, minute: 30),
          confirmText: "Set End Time   ",
        );

        if (endTime != null) {
          // Check if the selected day and time range already exist in the list
          final isDuplicate = _classSchedule.any((entry) =>
              entry.contains(selectedDay) &&
              entry.contains(startTime.format(context)) &&
              entry.contains(endTime.format(context)));

          if (!isDuplicate) {
            setState(() {
              _classSchedule.add(
                  '$selectedDay (${startTime.format(context)} - ${endTime.format(context)})');
            });
          } else {
            // Show toast message for duplicate selection
            Fluttertoast.showToast(
              msg: "This Day & Time already added! Try another...",
              toastLength: Toast.LENGTH_SHORT,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                      label: Text('Title'),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => value!.isEmpty ? 'Enter title' : null,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    minLines: 2,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                      label: Text('Description'),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter description' : null,
                  ),

                  const SizedBox(height: 16),

                  // Batch and seat
                  Row(
                    children: [
                      // Batch
                      Expanded(
                        child: TextFormField(
                          controller: _batchController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            hintText: 'Batch',
                            label: Text('Batch'),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter batch' : null,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Seat
                      Expanded(
                        child: TextFormField(
                          controller: _seatController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            hintText: 'Seats',
                            label: Text('Seats'),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter seats' : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price and discount
                  Row(
                    children: [
                      // Price
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            hintText: 'Price',
                            label: Text('Price'),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter price' : null,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Discount
                      Expanded(
                        child: TextFormField(
                          controller: _discountController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            hintText: 'Discount',
                            label: Text('Discount'),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter discount' : null,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Course Start And Finish Date',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  // Start - finish date
                  if (_enrollStart == null || _enrollFinish == null)
                    ElevatedButton(
                      onPressed: () async {
                        await _pickDateRangeDialog();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Enroll Start & Finish Date',
                            style: TextStyle(height: 2.2, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                  if (_enrollStart != null || _enrollFinish != null)
                    Row(
                      children: [
                        // Start date
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _pickDateRangeDialog();
                            },
                            child: Text(
                              DateFormat('dd MMMM yyyy').format(_enrollStart!),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // End date
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _pickDateRangeDialog();
                            },
                            child: Text(
                              DateFormat('dd MMMM yyyy').format(_enrollFinish!),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

                  Text(
                    'Class Date, Day & Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  // Class start, schedule
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class Start Date
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _pickClassStartDateTime();
                          },
                          child: _classStartDate == null
                              ? const Text('Class Start Date')
                              : Text(
                                  DateFormat('dd MMMM, yyyy (EEEE)')
                                      .format(_classStartDate!),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(height: 1.2),
                                ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Class Schedule
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _pickClassSchedule();
                          },
                          child: const Text(
                            'Class Schedule',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Day & time list
                  if (_classSchedule.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade500),
                        color: Colors.grey.shade50,
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 4, 4),
                        shrinkWrap: true,
                        itemCount: _classSchedule.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _classSchedule[index],
                              style: const TextStyle(fontSize: 15),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _classSchedule.removeAt(index);
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Add btn
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          // Check if enrollment start and finish dates are selected
                          if (_enrollStart == null || _enrollFinish == null) {
                            Fluttertoast.showToast(
                              msg:
                                  "Please select enrollment start and finish dates",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            return;
                          }

                          // Check if class start date is selected
                          if (_classStartDate == null) {
                            Fluttertoast.showToast(
                              msg: "Please select class start date",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            return;
                          }

                          // Check if class schedule is added
                          if (_classSchedule.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please add class schedule",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            return;
                          }

                          // If all validations pass, proceed with adding the course
                          setState(() {
                            _isProgress = true;
                          });

                          // Create CourseModel object
                          CourseModel courseModel = CourseModel(
                            courseTitle: _titleController.text.trim(),
                            courseDescription:
                                _descriptionController.text.trim(),
                            courseBatch: _batchController.text.trim(),
                            courseSeats: int.parse(_seatController.text.trim()),
                            coursePrice:
                                int.parse(_priceController.text.trim()),
                            discountRate:
                                int.parse(_discountController.text.trim()),
                            enrollStart: _enrollStart!,
                            enrollFinish: _enrollFinish!,
                            classStartDate: _classStartDate!,
                            classSchedule: _classSchedule,
                            instructorsList: [],
                            enrolledStudents: [],
                            courseImage:
                                'https://designshack.net/wp-content/uploads/placeholder-image.png',
                          );

                          // Add course to Firestore
                          var ref =
                              FirebaseFirestore.instance.collection('courses');

                          await ref.add(courseModel.toJson()).then((_) {
                            setState(() {
                              _isProgress = false;
                            });
                            Fluttertoast.showToast(
                              msg: "Course added successfully",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }).catchError((error) {
                            setState(() {
                              _isProgress = false;
                            });
                            Fluttertoast.showToast(
                              msg: "Failed to add course: $error",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          });
                        }
                      },
                      child: _isProgress
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Course'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
