import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sofolit/utils/date_time_formatter.dart';

class AddLive extends StatefulWidget {
  const AddLive({
    super.key,
    required this.courseID,
    required this.moduleNo,
  });

  final String courseID;
  final int moduleNo;

  @override
  State<AddLive> createState() => _AddLiveState();
}

class _AddLiveState extends State<AddLive> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _classNoController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _classLinkController = TextEditingController();

  bool _isProgress = false;

  DateTime? _selectedClassDateTime;

  //
  _pickDateAndTime() async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 22, minute: 00),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedClassDateTime = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    _classLinkController.text = 'https://meet.google.com/fwm-phne-cbe';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Live Class'),
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
              // class no
              TextFormField(
                controller: _classNoController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                  hintText: '1',
                  labelText: 'Class No',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter class no';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return '"$value" is not a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                  labelText: 'Title',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),

              // const SizedBox(height: 16),
              //
              // //url
              // TextFormField(
              //   controller: _descriptionController,
              //   decoration: const InputDecoration(
              //     contentPadding: EdgeInsets.all(16),
              //     border: OutlineInputBorder(),
              //     hintText: 'URL',
              //     labelText: 'URL',
              //   ),
              //   keyboardType: TextInputType.url,
              //   validator: (value) => value!.isEmpty ? 'Enter url' : null,
              // ),

              const SizedBox(height: 8),

              Text(
                'Class Date and Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 4),

              // Start - finish date
              ElevatedButton(
                onPressed: () async {
                  await _pickDateAndTime();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedClassDateTime == null
                          ? 'Class Date and Time'
                          : DTFormatter.dateWithTime(_selectedClassDateTime!),
                      style: const TextStyle(height: 2.2, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //class link
              TextFormField(
                controller: _classLinkController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Class Link',
                  labelText: 'Class Link',
                ),
                keyboardType: TextInputType.url,
                // validator: (value) => value!.isEmpty ? 'Enter url' : null,
              ),

              const SizedBox(height: 24),

              //
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_globalKey.currentState!.validate()) {
                      if (_selectedClassDateTime == null) {
                        Fluttertoast.showToast(
                          msg: "Please select class date and time",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        return;
                      }

                      setState(() {
                        _isProgress = true;
                      });

                      String classID =
                          '${DateTime.now().millisecondsSinceEpoch}';
                      //
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.courseID)
                          .collection('classes')
                          .doc(classID)
                          .set({
                        'moduleNo': widget.moduleNo,
                        'classNo': int.parse(_classNoController.text.trim()),
                        'classID': classID,
                        'classTitle': _titleController.text.trim(),
                        'classDate': _selectedClassDateTime,
                        'classLink': [_classLinkController.text.trim()],
                        'classVideo': [''],
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
