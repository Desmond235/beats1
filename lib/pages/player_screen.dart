import 'package:beats/const/colors.dart';
import 'package:beats/const/text_style.dart';
import 'package:beats/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, required this.data});

  final List<SongModel> data;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    artworkHeight: 300,
                    artworkWidth: 300,
                    artworkBorder: BorderRadius.circular(10),
                    id: data[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Obx(
                  () => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextScroll(
                          data[controller.playIndex.value].displayNameWOExt,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(40, 0)),

                          pauseBetween: const Duration(seconds: 3),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: bgDarkColor,
                                    fontSize: 24,
                                  ),

                          // child: Text(
                          //   data[controller.playIndex.value].displayNameWOExt,
                          //   textAlign: TextAlign.center,
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 2,
                          //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          //         color: bgDarkColor,
                          //         fontSize: 24,
                          //       ),
                          // ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data[controller.playIndex.value].artist ??
                            'Unknown Artist',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: bgDarkColor,
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: sliderColor,
                                activeColor: sliderColor,
                                inactiveColor: bgColor,
                                min: Duration.zero.inSeconds.toDouble(),
                                value:
                                    controller.value.value.inSeconds.toDouble(),
                                max: controller.max.value.inSeconds.toDouble(),
                                onChanged: (value) {
                                  controller.seekToPosition(value.toInt());
                                  value = value;
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.playSong(
                                  data[controller.playIndex.value - 1].uri,
                                  controller.playIndex.value - 1,
                                );
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 45,
                                color: bgDarkColor,
                              )),
                          Obx(
                            () => IconButton(
                                onPressed: controller.pauseResume,
                                icon: controller.isPlaying.value
                                    ? const Icon(
                                        Icons.pause_circle_rounded,
                                        color: bgDarkColor,
                                        size: 65,
                                      )
                                    : const Icon(
                                        Icons.play_circle_rounded,
                                        color: bgDarkColor,
                                        size: 65,
                                      )),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.playSong(
                                data[controller.playIndex.value + 1].uri,
                                controller.playIndex.value + 1,
                              );
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 45,
                              color: bgDarkColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
