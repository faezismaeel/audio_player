import 'package:audio_player_app/audio_player_bloc/audio_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<DropdownMenuItem<double>> items = const [
    DropdownMenuItem<double>(
      value: 0.5,
      child: Text('0.5x'),
    ),
    DropdownMenuItem<double>(
      value: 1.0,
      child: Text('1x'),
    ),
    DropdownMenuItem<double>(
      value: 1.5,
      child: Text('1.5x'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Audio Player"),
          centerTitle: true,
        ),
        body: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          bloc: context.read<AudioPlayerCubit>()
            ..init(
                context,
                AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 750))),
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: state.duration.inSeconds.toDouble(),
                  min: 0.0,
                  max: state.position.inSeconds.toDouble(),
                  onChanged: (double value) {
                    context
                        .read<AudioPlayerCubit>()
                        .seekToSecond(value.toInt());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<AudioPlayerCubit>().seekToSecond(
                            (state.duration.inSeconds - 10)
                                .clamp(0, state.position.inSeconds));
                      },
                      icon: const Icon(
                        Icons.replay_10,
                        size: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    state.audioExists
                        ? GestureDetector(
                            child: ClipOval(
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.blue,
                                child: Center(
                                  child: AnimatedIcon(
                                    size: 50,
                                    icon: AnimatedIcons.play_pause,
                                    progress: state.animationController!,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              context.read<AudioPlayerCubit>().playAudio();
                            },
                          )
                        : Container(
                            child: state.downloading
                                ? CircularProgressIndicator(
                                    value: state.progress,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await context
                                          .read<AudioPlayerCubit>()
                                          .downloadAudio(context);
                                    },
                                    icon: const Icon(Icons.download),
                                  ),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      child: ClipOval(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                          child: const Center(
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        context.read<AudioPlayerCubit>().stopAudio();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AudioPlayerCubit>().seekToSecond(
                            (state.duration.inSeconds + 10)
                                .clamp(0, state.position.inSeconds));
                      },
                      icon: const Icon(
                        Icons.forward_10,
                        size: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton<double>(
                        value: state.playBackRate,
                        onChanged: (value) {
                          context
                              .read<AudioPlayerCubit>()
                              .setPlaybackSpeedRate(value!);
                        },
                        items: items),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       bool res = await permissionRequest();
                //       if (res) {
                //         downloadDialog(context);
                //       } else {
                //         print("No permission to read and write.");
                //       }
                //     },
                //     child: const Text("Download"))
              ],
            );
          },
        ));
  }

  // Future<dynamic> downloadDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) {
  //         return DownloadingDialog();
  //       });
  // }
}

Future<bool> permissionRequest() async {
  PermissionStatus result;
  result = await Permission.storage.request();
  if (result.isGranted) {
    return true;
  }
  return false;
}


// Future<dynamic> downloadAudio(String url) async {
//   String dir = (await getApplicationDocumentsDirectory()).path;
//   File file = File('$dir/audios');
//   var request = await get(Uri.parse(url));
//   var bytes = request.bodyBytes;
//   await file.writeAsBytes(bytes);
//   print(file.path);
// }
