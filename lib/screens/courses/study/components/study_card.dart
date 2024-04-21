import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/date_time_formatter.dart';
import '../../../../utils/open_app.dart';

class StudyCard extends StatefulWidget {
  const StudyCard({super.key, required this.data, required this.index});

  final QueryDocumentSnapshot data;
  final int index;

  @override
  State<StudyCard> createState() => _StudyCardState();
}

class _StudyCardState extends State<StudyCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: isExpanded ? Colors.yellow : Colors.transparent),
        ),
        child: ExpansionTile(
          maintainState: true,
          textColor: Colors.black,
          iconColor: Colors.black,
          onExpansionChanged: (state) {
            print(isExpanded);
            isExpanded = state;

            setState(() {});
          },
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Class ${widget.data.get('class')} - ${widget.data.get('title')}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                //date
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(DTFormatter.dateWithDay(widget.data.get('time'))),
                  ],
                ),

                const SizedBox(width: 10),

                //time
                Row(
                  children: [
                    const Icon(Icons.watch_later_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(DTFormatter.timeFormat(widget.data.get('time'))),
                  ],
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Theme(
                  data:
                      ThemeData().copyWith(dividerColor: Colors.grey.shade500),
                  child: const Divider(height: 2),
                ),
                const SizedBox(height: 12),
                Text(
                  '${widget.data.get('description')}',
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    if (widget.data.get('recording') == '' &&
                        widget.data.get('resource') == '')
                      Container(
                        margin: const EdgeInsets.only(top: 12, right: 10),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(48, 40),
                          ),
                          icon: const Icon(
                            Icons.video_call_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            OpenApp.withUrl(widget.data.get('meeting'));
                          },
                          label: const Text(
                            'Live Class',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    //
                    if (widget.data.get('recording') != '')
                      Container(
                        margin: const EdgeInsets.only(top: 12, right: 10),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade50,
                            minimumSize: const Size(48, 40),
                          ),
                          icon: const Icon(
                            Icons.drive_file_move_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            OpenApp.withUrl(widget.data.get('recording'));
                          },
                          label: const Text(
                            'Recoding',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                    //
                    if (widget.data.get('resource') != '')
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            minimumSize: const Size(48, 40),
                          ),
                          icon: const Icon(
                            Icons.link_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            OpenApp.withUrl(widget.data.get('resource'));
                          },
                          label: const Text(
                            'Resource',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
