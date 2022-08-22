import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_audio_waveform/view/playback_page.dart';
import 'package:sound_audio_waveform/view/record_page.dart';
import 'package:sound_audio_waveform/view/widgets/record_wave.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Waveforms',
      debugShowCheckedModeBanner: false,
      initialRoute: RecordPage.id,
      routes: {
        RecordPage.id: (context) => RecordPage(),
        PlayBackPage.id: (context) => PlayBackPage()
      },
    );
  }
}
