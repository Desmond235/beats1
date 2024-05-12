import 'package:beats/const/colors.dart';
import 'package:beats/const/text_style.dart';
import 'package:beats/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: whiteColor,
              ),
            )
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text('Beats',
              style: ourStyle(
                size: 18,
              )),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
              orderType: OrderType.ASC_OR_SMALLER,
              ignoreCase: true,
              uriType: UriType.EXTERNAL,
              sortType: null),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Song found',
                  style: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        tileColor: bgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          snapshot.data![index].displayNameWOExt,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Text(
                          snapshot.data?[index] == null
                              ? 'Unknown artist'
                              : snapshot.data![index].artist!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: whiteColor),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow_outlined,
                            color: whiteColor,
                            size: 26,
                          ),
                        ),
                        onTap: () {
                          controller.playSong(snapshot.data![index].uri);
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
