import 'dart:async';
import 'dart:io';
import 'package:audio_player_app/download_audio.dart';
import 'package:audio_player_app/widgets/downloading_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_player_state.dart';
part 'audio_player_cubit.freezed.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(AudioPlayerState.initial());
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  File file = File("/storage/emulated/0/Download/better-day-186374.mp3");

  init(BuildContext context,AnimationController animationController) async {
    emit(state.copyWith(animationController: animationController));

    if(await file.exists()){
      emit(state.copyWith(audioExists: true));
    }

    _durationSubscription =
        state.audioPlayer!.onDurationChanged.listen((Duration duration) {
      emit(state.copyWith(position: duration));
    });

    _positionSubscription =
        state.audioPlayer!.onPositionChanged.listen((Duration duration) {
      emit(state.copyWith(duration: duration));
    });
  }

  reset() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
  }

  playAudio() async {
    if (!state.isPlaying) {
      if (await file.exists()) {
        // emit(state.copyWith(audioExists: true));
        state.audioPlayer!.play(DeviceFileSource(file.path));
      } else {
        print("not exist");
        //  await downloadAudio(context);
        // if(await file.exists()){
        //   state.audioPlayer!.play(DeviceFileSource(file.path));
        // }
      }
      // AssetSource("audios/audio_sample.mp3")
    } else {
      state.audioPlayer!.pause();
    }
    if (state.isPlaying) {
      state.animationController!.reverse();
    } else {
      state.animationController!.forward();
    }
    emit(state.copyWith(isPlaying: !state.isPlaying));
  }

  seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    state.audioPlayer!.seek(newDuration);
  }

  setPlaybackSpeedRate(double rate) {
    state.audioPlayer!.setPlaybackRate(rate);
    emit(state.copyWith(playBackRate: rate));
  }

  stopAudio() {
    if (state.isPlaying) {
      state.audioPlayer!.stop();
      emit(state.copyWith(isPlaying: true, duration: const Duration()));
      state.animationController!.reverse();
    }
  }

  Future<void> downloadDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) {
        return const DownloadingDialog();
      },
    );
  }

  Future<void> downloadAudio(BuildContext context) async{
     FileDownload().startDownloading(context, (recivedBytes, totalBytes)  {
      emit(state.copyWith(downloading: true,progress: recivedBytes/totalBytes)); 
      if(recivedBytes == totalBytes){
        emit(state.copyWith(downloading: false,audioExists: true));
      }
      });
      
  }
}