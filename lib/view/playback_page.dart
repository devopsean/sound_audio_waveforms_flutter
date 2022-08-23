import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_audio_waveform/view/record_page.dart';
import 'package:sound_audio_waveform/view/widgets/record_wave.dart';

class PlayBackPage extends StatefulWidget {
  const PlayBackPage({Key? key, this.playerController, this.patha})
      : super(key: key);
  final PlayerController? playerController;
  final String? patha;
  static const id = 'playback_page';
  @override
  State<PlayBackPage> createState() => _PlayBackPageState();
}

class _PlayBackPageState extends State<PlayBackPage>
    with WidgetsBindingObserver {
  String? path;
  Directory? appDirectory;
  void _disposeControllers() {
    // widget.playerController!.dispose();
  }
  PlayerController? controlla;
  @override
  void initState() {
    // widget.playerController!.addListener(() {
    //   if (mounted) setState(() {});
    // });
    preparePlayers();
    super.initState();
  }

  void preparePlayers() async {
    await controlla!.preparePlayer(widget.patha!);
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _disposeControllers();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    // _preparePlayers();
    path = "${appDirectory!.path}/cloudIQrecording.aac";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RecordPage.id, (route) => false);
        throw false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
          elevation: 1,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 1.5,
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'Play saved recording',
                style: TextStyle(
                  color: Color(
                    0xff3a7fbb,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                //  Text('${widget.playerController!.playerState}'),
                WaveBubble(
                  playerController: widget.playerController!,
                  isPlaying: widget.playerController!.playerState ==
                      PlayerState.playing,
                  onTap: () => _playOrPlausePlayer(widget.playerController!),
                ),
                //    Text('${controlla!.playerState}'),
                // WaveBubble(
                //   playerController: controlla!,
                //   isPlaying:
                //       controlla!.playerState == PlayerState.playing,
                //   onTap: () => _playOrPlausePlayer(controlla!),
                // ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }
}
