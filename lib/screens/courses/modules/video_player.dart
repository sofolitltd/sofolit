import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../utils/duration_formater.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final videoURL = 'https://youtu.be/l-R2G83Ecw4';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    //
    final videoID = YoutubePlayer.convertUrlToId(videoURL);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
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
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(width: 16),
                        // date
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 1,
                            horizontal: 10,
                          ),
                          child: Text(
                            '18 April - 24 April',
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
                    const SizedBox(height: 16),
                    //2
                    Text(
                      'The ultimate freelancing guide',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                    ),
                    const Divider(),

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
