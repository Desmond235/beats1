import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _onAudioQuery = OnAudioQuery();

  List<SongModel> songs = [];

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  int? _currentSongIndex;

  bool _isPlaying = false;

  /* 
    G E T T E R S 

 */
  OnAudioQuery get onAudioQuery => _onAudioQuery;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration? get duration => _duration;

  void listenToDuration() {
    _audioPlayer.positionStream.listen((newPostion) {
      _position = newPostion;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      _duration = totalDuration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        seekToNextSong();
      }
    });
  }

  void playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      _audioPlayer.play();
      _isPlaying = true;
      listenToDuration();
    } on Exception catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  void seek(seconds) {
    _audioPlayer.seek(Duration(seconds: seconds));
  }

  void seekToPreviousSong() {
    if (_position.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = songs.length - 1;
      }
    }
  }

  void seekToNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < songs.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void checkPermission() async {
    final permission = await Permission.storage.request();
    if (permission != PermissionStatus.granted) {
      checkPermission();
    }
  }

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    notifyListeners();
  }
}
