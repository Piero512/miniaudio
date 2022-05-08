import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:miniaudio/miniaudio.dart';

void main() {
  runApp(const MyApp());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool playing = false;
  MiniAudioDecoder? decoder;
  MiniAudioDevice? device;
  late ma_device_callback_proc cb = DynamicLibrary.open('miniaudio_plugin.dll')
      .lookup('MiniAudioReadDecoderDataCallback');

  void openFile(String path) {
    final dec = MiniAudio.openDecoder(path);
    decoder = dec;
    device = MiniAudio.getDefaultPlaybackDevice(cb, dec.decoder.cast<Void>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of miniaudio'),
      ),
      body: Column(children: [
        Text("Status: ${playing ? 'Playing...' : 'Stopped'}"),
        Center(
          child: Row(children: [
            IconButton(
              onPressed: () {
                play();
              },
              icon: const Icon(
                Icons.play_arrow,
              ),
            ),
            IconButton(
              onPressed: () {
                pause();
              },
              icon: const Icon(
                Icons.pause,
              ),
            )
          ]),
        ),
      ]),
    );
  }

  void pause() {}

  void play() {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}
