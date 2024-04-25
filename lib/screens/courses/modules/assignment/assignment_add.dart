import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({
    super.key,
    required this.courseID,
    required this.moduleNo,
    required this.classNo,
    required this.classTitle,
    required this.classDate,
  });

  final String courseID;
  final int moduleNo;
  final int classNo;
  final String classTitle;
  final DateTime classDate;

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _classNoController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isProgress = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _classNoController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _classNoController.text = widget.classNo.toString();
    _titleController.text = widget.classTitle.toString();
    _descriptionController.text = 'Submit assignments before deadline';
    _selectedDateTime = widget.classDate.add(const Duration(days: 3));
    super.initState();
  }

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;

  //Method for showing the date picker
  _pickDateDialog() async {
    //
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      _selectedDate = pickedDate;
      setState(() {});
    });
  }

  _pickTimeDialog() async {
    await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 22, minute: 00),
    ).then((pickedTime) {
      if (pickedTime == null) return;
      _selectedTime = pickedTime;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Assignment'),
      ),

      //
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 8, horizontal: width > 600 ? width * .2 : 8),
        child: Form(
          key: _globalKey,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // mark and date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //class no
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _classNoController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                        hintText: 'Class No',
                        label: Text('Class No'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter message' : null,
                    ),
                  ),

                  const SizedBox(width: 16),

                  //marks
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _marksController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                        hintText: 'Marks',
                        label: Text('Marks'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter message' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                  label: Text('Title'),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 16),

              //description
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                  label: Text('Description'),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.none,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),

              const SizedBox(height: 16),

              // time
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(56, 50)),
                onPressed: () async {
                  await _pickDateDialog();
                  if (_selectedDate == null) return;

                  await _pickTimeDialog();
                  if (_selectedTime == null) return;

                  _selectedDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );
                  print(_selectedDateTime);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                    ),

                    const SizedBox(width: 8),
                    //
                    Text(
                      _selectedDateTime == null
                          ? 'Deadline'.toUpperCase()
                          : DateFormat('dd MMM, yy(EEE) - hh:mm a')
                              .format(_selectedDateTime!)
                              .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedDateTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('No Date & Time picked!'),
                          action: SnackBarAction(
                              textColor: Colors.white,
                              label: 'Pick now',
                              onPressed: () async {
                                await _pickDateDialog();
                                if (_selectedDate == null) return;

                                await _pickTimeDialog();
                                if (_selectedTime == null) return;

                                _selectedDateTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute,
                                );
                                print(_selectedDateTime);
                              }),
                        ),
                      );
                    } else if (_globalKey.currentState!.validate()) {
                      setState(() {
                        _isProgress = true;
                      });

                      String assignmentID =
                          '${DateTime.now().millisecondsSinceEpoch}';
                      //
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.courseID)
                          .collection('assignments');

                      //
                      ref.doc(assignmentID).set({
                        'moduleNo': widget.moduleNo,
                        'classNo': int.parse(_classNoController.text),
                        'assignmentID': assignmentID,
                        'assignmentTitle': _titleController.text.trim(),
                        'assignmentDescription':
                            _descriptionController.text.trim(),
                        'assignmentMarks':
                            int.parse(_marksController.text.trim()),
                        'assignmentDate': _selectedDateTime,
                        'submitterList': [],
                      }).then((value) {
                        setState(() {
                          _isProgress = false;
                        });
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: _isProgress
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
