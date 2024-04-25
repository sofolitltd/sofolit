import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '/utils/date_time_formatter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.data});

  final QueryDocumentSnapshot data;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    //
    final videoID =
        YoutubePlayerController.convertUrlToId(widget.data.get('classVideo'));

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoID!,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        controller: _controller,
        aspectRatio: 16 / 9,
        autoFullScreen: false,
        builder: (context, player) {
          return Scaffold(
            body: SafeArea(
                child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(child: player),
                    // const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //module
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 12),
                                  child: Text(
                                    'Live',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // date
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    DTFormatter.dateWithDay(
                                        widget.data.get('classDate').toDate()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            //2
                            Text(
                              widget.data.get('classTitle'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ),
                            ),

                            const Divider(height: 32),

                            const SizedBox(height: 10),

                            const Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                await SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp],
                                ).then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('Back to Live Class'),
                            ),

                            //
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        });
  }
}
