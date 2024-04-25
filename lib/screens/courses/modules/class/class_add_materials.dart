import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofolit/utils/open_app.dart';

// https://youtu.be/Qo_5X3Gu0ls?si=Q0xwiN7BlMs7FjJX

class AddClassMaterials extends StatefulWidget {
  const AddClassMaterials({
    super.key,
    required this.courseID,
    required this.moduleNo,
    required this.classData,
  });

  final String courseID;
  final int moduleNo;
  final QueryDocumentSnapshot classData;

  @override
  State<AddClassMaterials> createState() => _AddClassMaterialsState();
}

class _AddClassMaterialsState extends State<AddClassMaterials> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _moduleNoController = TextEditingController();
  final TextEditingController _classNoController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool _isProgress = false;

  @override
  void initState() {
    _moduleNoController.text = widget.moduleNo.toString();
    _classNoController.text = widget.moduleNo.toString();
    _urlController.text = widget.classData.get('classVideo')[0].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Class Materials'),
        actions: [
          IconButton(
              onPressed: () {
                String path = 'https://youtube.com/@sofolitltd/videos';
                OpenApp.withUrl(path);
              },
              icon: const Icon(Icons.web_stories)),
        ],
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
              // module, class no
              Row(
                children: [
                  // module no
                  Expanded(
                    child: TextFormField(
                      controller: _moduleNoController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                        hintText: '1',
                        labelText: 'Module No',
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      enabled: false,
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
                  ),

                  const SizedBox(width: 16),

                  // class no
                  Expanded(
                    child: TextFormField(
                      controller: _classNoController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                        hintText: '1',
                        labelText: 'Class No',
                      ),
                      readOnly: true,
                      enabled: false,
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
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //url
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(),
                  hintText: 'URL',
                  labelText: 'URL',
                ),
                keyboardType: TextInputType.url,
                // validator: (value) => value!.isEmpty ? 'Enter url' : null,
              ),

              const SizedBox(height: 24),

              // btn
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_globalKey.currentState!.validate()) {
                      setState(() {
                        _isProgress = true;
                      });

                      //
                      var ref = FirebaseFirestore.instance
                          .collection('courses')
                          .doc(widget.courseID)
                          .collection('classes')
                          .doc(widget.classData.id)
                          .update({
                        'classVideo': _urlController.text.trim(),
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
