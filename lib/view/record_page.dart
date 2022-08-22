import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_audio_waveform/view/playback_page.dart';
import 'package:sound_audio_waveform/view/widgets/record_wave.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);
  static const id = 'record_page';
  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with WidgetsBindingObserver {
  late final RecorderController recorderController;

  late final PlayerController playerController5;

  String? path;
  String? musicFile;
  bool isRecording = false;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    _preparePlayers();
    path = "${appDirectory.path}/music.aac";
  }

  Future<ByteData> _loadAsset(String path) async {
    return await rootBundle.load(path);
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;

    playerController5 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  void _preparePlayers() async {
    ///prepare players based on previously saved files
    // ///audio-1
    // final file1 = File('${appDirectory.path}/audio1.mp3');
    // await file1.writeAsBytes(
    //     (await _loadAsset('assets/audios/audio1.mp3')).buffer.asUint8List());
    // playerController1.preparePlayer(file1.path);
    //
    // ///audio-2
    // final file2 = File('${appDirectory.path}/audio2.mp3');
    // await file2.writeAsBytes(
    //     (await _loadAsset('assets/audios/audio2.mp3')).buffer.asUint8List());
    // playerController2.preparePlayer(file2.path);
  }

  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     musicFile = result.files.single.path;
  //     await playerController6.preparePlayer(musicFile!);
  //   } else {
  //     debugPrint("File not picked");
  //   }
  // }

  void _disposeControllers() {
    recorderController.dispose();

    playerController5.dispose();
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
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 1,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              scale: 1.5,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Flutter Task',
              style: TextStyle(
                color: Color(
                  0xff3a7fbb,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xffffffff), Color(0xffd5ebff)])),
        child: SafeArea(
          child: Center(
            child: IconButton(
              onPressed: _startOrStopRecording,
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              color: Color(0xff207abf),
              iconSize: 50,
            ),
          ),
        ),
      ),
    );
  }



  void _startOrStopRecording() async {
    if (isRecording) {
      recorderController.reset();
      final path = await recorderController.stop(false);
      if (path != null) await playerController5.preparePlayer(path);
     // Navigator.pushNamed(context, PlayBackPage.id);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayBackPage(playerController: playerController5,)));
    } else {
      await recorderController.record(path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }
}
