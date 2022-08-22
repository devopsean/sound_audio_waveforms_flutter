import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:sound_audio_waveform/view/widgets/record_wave.dart';

class PlayBackPage extends StatefulWidget {
  const PlayBackPage({Key? key, this.playerController}) : super(key: key);
  final PlayerController? playerController;
  static const id = 'playback_page';
  @override
  State<PlayBackPage> createState() => _PlayBackPageState();
}

class _PlayBackPageState extends State<PlayBackPage> with WidgetsBindingObserver{


  void _disposeControllers() {

    widget.playerController!.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: WaveBubble(
            playerController: widget.playerController!,
            isPlaying:
                widget.playerController!.playerState == PlayerState.playing,
            onTap: () => _playOrPlausePlayer(widget.playerController!),
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
