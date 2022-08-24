import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class WaveBubble extends StatelessWidget {
  final PlayerController playerController;
  final VoidCallback onTap;

  final bool isPlaying;

  const WaveBubble({
    Key? key,
    required this.playerController,
    required this.onTap,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 6,
          top: 6,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff207abf),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              color: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width / 2, 70),
              playerController: playerController,
              density: 1.5,
              playerWaveStyle: const PlayerWaveStyle(
                scaleFactor: 0.8,
                fixedWaveColor: Colors.white30,
                liveWaveColor: Colors.white,
                waveCap: StrokeCap.butt,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
