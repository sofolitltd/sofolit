import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStudyPlan extends StatefulWidget {
  const AddStudyPlan({super.key, required this.uid});

  final String uid;

  @override
  State<AddStudyPlan> createState() => _AddStudyPlanState();
}

class _AddStudyPlanState extends State<AddStudyPlan> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingController = TextEditingController();
  final TextEditingController _recordingController = TextEditingController();
  final TextEditingController _resourceController = TextEditingController();

  bool _isProgress = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;

  //Method for showing the date picker
  _pickDateDialog() async {
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
      initialTime: TimeOfDay.now(),
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
        title: const Text('Add Study Plan'),
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
              // class and date
              Row(
                children: [
                  //class
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                        controller: _classController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(),
                          hintText: 'Class',
                          label: Text('Class'),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter message';
                          }
                          final n = num.tryParse(value);
                          if (n == null) {
                            return '"$value" is not a valid number';
                          }
                          return null;
                        }),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
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
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(_selectedDateTime == null
                          ? 'Date & Time'.toUpperCase()
                          : DateFormat('EEE, dd MMMM, yyy\nhh:mm a')
                              .format(_selectedDateTime!)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // t
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

              //d
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
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 16),

              //m
              TextFormField(
                controller: _meetingController,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Meeting link',
                  label: Text('Meeting link'),
                ),
                keyboardType: TextInputType.url,
                // validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 16),

              //rec
              TextFormField(
                controller: _recordingController,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Recording Link',
                  label: Text('Recording Link'),
                ),
                keyboardType: TextInputType.url,
                // validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 16),

              //res
              TextFormField(
                controller: _resourceController,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Resource Link',
                  label: Text('Resource Link'),
                ),
                keyboardType: TextInputType.url,
                // validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),

              const SizedBox(height: 24),

              //
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedDate == null) {
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

                      //
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.uid)
                          .collection("modules")
                          .doc("Sy1SqhfIBLAkhVYxVzQA");

                      // record
                      if (_recordingController.text.trim().isNotEmpty) {
                        await ref.collection('recoding').doc().set({
                          'class': int.parse(_classController.text.trim()),
                          'title': _titleController.text.trim(),
                          'description': _descriptionController.text.trim(),
                          'url': _recordingController.text.trim(),
                          'time': DateTime.now(),
                        });
                      }

                      // study
                      await ref.collection('study').doc().set({
                        'class': int.parse(_classController.text.trim()),
                        'title': _titleController.text.trim(),
                        'description': _descriptionController.text.trim(),
                        'meeting': _meetingController.text.trim().isNotEmpty
                            ? _meetingController.text.trim()
                            : 'https://join.skype.com/pQBCn60chLKI',
                        'resource': _resourceController.text.trim().isEmpty
                            ? ''
                            : _resourceController.text.trim(),
                        'recording': _recordingController.text.trim().isEmpty
                            ? ''
                            : _recordingController.text.trim(),
                        'time': _selectedDateTime,
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
                      : const Text('Add now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
