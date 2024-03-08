import 'package:audio_player_app/audio_player_bloc/audio_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        bloc: context.read<AudioPlayerCubit>()..init(context),
        builder: (context, state) {
          int minutes = state.duration.inMinutes.remainder(60);
          int seconds = state.duration.inSeconds.remainder(60);
          return Center(
            child: Stack(children: [
              Container(
                height: 90,
                width: 320,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    state.audioExists
                        ? IconButton(
                            onPressed: () {
                              context.read<AudioPlayerCubit>().playAudio();
                            },
                            icon: !state.isPlaying
                                ? const Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.pause,
                                    size: 40,
                                  ))
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
                                    icon: const Icon(
                                      Icons.download,
                                      size: 30,
                                    ),
                                  ),
                          ),
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
                    GestureDetector(
                      onTap: () {
                        double currentRate = state.playBackRate;
                        double newRate = currentRate == 1.0
                            ? 1.5
                            : currentRate == 1.5
                                ? 0.5
                                : 1.0;
                        context
                            .read<AudioPlayerCubit>()
                            .setPlaybackSpeedRate(newRate);
                      },
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "${state.playBackRate == 1.0 ? '1' : state.playBackRate} x",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 60,
                  left: 40,
                  child: state.duration.inSeconds < 60
                      ? Text('0:${state.duration.inSeconds.toString()}')
                      : Text('$minutes:$seconds'))
            ]),
          );
        },
      ),
    );
  }
}
