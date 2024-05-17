import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
 
  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = Duration.zero.obs;
  var value = Duration.zero.obs;

  

  @override
  void onInit() {
    checkPermission();
    super.onInit();
  }

  void pauseResume() {
    if (isPlaying.value) {
      audioPlayer.pause();
      isPlaying(false);
    } else {
      audioPlayer.play();
      isPlaying(true);
    }
  }

  void skipToPreviousSong() {
    if (value.value.inSeconds > 2) {
      seekToPosition(Duration.zero);
    }
  }

  void updatePositionAndDuration() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split('.')[0];
      max.value = d ?? Duration.zero;
    });

    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split('.')[0];
      value.value = p;
    });
  }

  void seekToPosition(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  void playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      audioPlayer.play();
      isPlaying(true);
      updatePositionAndDuration();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void checkPermission() async {
    final permission = await Permission.storage.request();
    if (permission.isGranted) {
    } else {
      checkPermission();
    }
  }
}
