import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddModule extends StatefulWidget {
  const AddModule({super.key, required this.uid});

  final String uid;

  @override
  State<AddModule> createState() => _AddModuleState();
}

class _AddModuleState extends State<AddModule> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _moduleNoController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isProgress = false;

  DateTime? _selectedStartTime;
  DateTime? _selectedFinishTime;

  Future<void> _pickDateRangeDialog() async {
    await Future.delayed(
        const Duration(milliseconds: 100)); // Add a slight delay

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
                primary: Theme.of(context).colorScheme.primary,
              ),
        ),
        child: child!,
      ),
    );

    if (pickedDateRange == null) return;

    // Validate the picked date range
    setState(() {
      _selectedStartTime = pickedDateRange.start;
      _selectedFinishTime = pickedDateRange.end;
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
              // m
              TextFormField(
                controller: _moduleNoController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                  hintText: '1',
                  labelText: 'Module',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter module';
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
              const SizedBox(height: 16),

              //des
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                minLines: 2,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
              ),

              const SizedBox(height: 8),

              Text(
                'Course Start And Finish Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 4),

              // Start - finish date
              if (_selectedStartTime == null || _selectedFinishTime == null)
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

              if (_selectedStartTime != null || _selectedFinishTime != null)
                Row(
                  children: [
                    // Start date
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _pickDateRangeDialog();
                        },
                        child: Text(
                          DateFormat('dd MMMM yyyy')
                              .format(_selectedStartTime!),
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
                          DateFormat('dd MMMM yyyy')
                              .format(_selectedFinishTime!),
                        ),
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
                    if (_globalKey.currentState!.validate()) {
                      if (_selectedStartTime == null ||
                          _selectedFinishTime == null) {
                        Fluttertoast.showToast(
                          msg:
                              "Please select enrollment start and finish dates",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        return;
                      }

                      setState(() {
                        _isProgress = true;
                      });

                      //
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.uid)
                          .collection("modules")
                          .doc();

                      // study
                      await ref.set({
                        'moduleNo': int.parse(_moduleNoController.text.trim()),
                        'moduleTitle': _titleController.text.trim(),
                        'moduleDescription': _descriptionController.text.trim(),
                        'startTime': _selectedStartTime!,
                        'finishTime': _selectedFinishTime!,
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
