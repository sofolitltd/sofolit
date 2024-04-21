import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

              //des
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

              // mark and date
              Row(
                children: [
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
                          ? 'Deadline'.toUpperCase()
                          : DateFormat('EEE, dd MMM, yy\nhh:mm a')
                              .format(_selectedDateTime!)),
                    ),
                  ),
                ],
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

                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.uid)
                          .collection('assignment');
                      ref.doc().set({
                        'title': _titleController.text.trim(),
                        'description': _descriptionController.text.trim(),
                        'status': 'Pending',
                        'marks': int.parse(_marksController.text.trim()),
                        'time': _selectedDateTime,
                        'feedback': '',
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
