part of 'audio_player_cubit.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {

  const factory AudioPlayerState({
   AnimationController? animationController,
   AudioPlayer? audioPlayer,
  @Default(Duration())Duration duration,
  @Default(Duration(seconds: 0))Duration position,
  @Default(Duration(seconds: 0))Duration slider,
  @Default(false)bool isPlaying,
  @Default(false)bool audioExists,
  @Default(false)bool downloading,
  @Default(1.0)double playBackRate,
  @Default(0.0)double? progress,
  }) = _AudioPlayerState;


  factory AudioPlayerState.initial() => AudioPlayerState(
    audioPlayer: AudioPlayer()
  );
}
