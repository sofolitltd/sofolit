import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/utils/date_time_formatter.dart';
import '/utils/duration_formatter.dart';

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
    final videoID = YoutubePlayer.convertUrlToId(widget.data.get('videoURL'));

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        );
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp],
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          print('Ready to play');
        },
        onEnded: (metaData) {
          SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp],
          );
          _controller.reload();
          Future.delayed(const Duration(seconds: 3)).then((value) {
            _controller.pause();
          });
        },
        bottomActions: [
          CurrentPosition(),
          Text(
            ' / ${durationFormatter(_controller.metadata.duration.inMilliseconds)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          FullScreenButton(),
        ],
        topActions: const [
          BackButton(color: Colors.white),
          Spacer(),
          PlaybackSpeedButton(),
        ],
      ),
      builder: (context, player) => Scaffold(
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            player,
            // const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                      widget.data.get('title'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                    ),

                    const Divider(height: 32),

                    const SizedBox(height: 10),

                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back to Live Class'),
                    ),

                    //
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
