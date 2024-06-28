import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../state/lat_lng_temple/lat_lng_temple.dart';
import '../../state/routing/routing.dart';
import '../../state/tokyo_train/tokyo_train.dart';
import '../_parts/_caution_dialog.dart';
import '../_parts/_temple_dialog.dart';
import 'lat_lng_temple_map_alert.dart';
import 'not_reach_temple_station_list_alert.dart';

class TempleTrainStationListAlert extends ConsumerStatefulWidget {
  const TempleTrainStationListAlert({super.key});

  @override
  ConsumerState<TempleTrainStationListAlert> createState() =>
      _TempleTrainListAlertState();
}

class _TempleTrainListAlertState
    extends ConsumerState<TempleTrainStationListAlert> {
  int reachTempleNum = 0;






  ///
  @override
  void initState() {
    super.initState();

    ref.read(tokyoTrainProvider.notifier).getTokyoTrain();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final tokyoTrainState = ref.watch(tokyoTrainProvider);

    final startStationId =
        ref.watch(routingProvider.select((value) => value.startStationId));

    final latLngTempleList = ref
        .watch(latLngTempleProvider.select((value) => value.latLngTempleList));

    getReachTempleNum();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (tokyoTrainState.tokyoStationMap[startStationId] !=
                                null)
                            ? tokyoTrainState
                                .tokyoStationMap[startStationId]!.stationName
                            : '-----',
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(latLngTempleList.length.toString()),
                          Text(reachTempleNum.toString()),
                          Text(
                            (latLngTempleList.length - reachTempleNum)
                                .toString(),
                            style: const TextStyle(color: Colors.orangeAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              TempleDialog(
                                context: context,
                                widget: const NotReachTempleStationListAlert(),
                                paddingLeft: context.screenSize.width * 0.2,
                              );
                            },
                            icon: Icon(
                              Icons.train,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          IconButton(
                            onPressed: (startStationId == '')
                                ? null
                                : () {
                                    if (latLngTempleList.isEmpty) {
                                      caution_dialog(
                                          context: context, content: 'no hit');

                                      return;
                                    }

                                    TempleDialog(
                                      context: context,
                                      widget: LatLngTempleMapAlert(
                                        templeList: latLngTempleList,
                                        station: tokyoTrainState
                                            .tokyoStationMap[startStationId],
                                      ),
                                    );
                                  },
                            icon: Icon(
                              Icons.map,
                              color: (startStationId != '' &&
                                      latLngTempleList.isNotEmpty)
                                  ? Colors.yellowAccent.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tokyoTrainState.tokyoTrainList.map((e) {
                    return ExpansionTile(
                      title: Text(
                        e.trainName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: e.station.map((e2) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: (e2.id == startStationId)
                                  ? Colors.yellowAccent
                                  : Colors.white,
                              fontSize: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e2.stationName),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(latLngTempleProvider.notifier)
                                        .getLatLngTemple(param: {
                                      'latitude': e2.lat,
                                      'longitude': e2.lng,
                                    });

                                    ref
                                        .read(routingProvider.notifier)
                                        .setStartStationId(id: e2.id);
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: (e2.id == startStationId)
                                        ? Colors.yellowAccent.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  void getReachTempleNum() {
    reachTempleNum = 0;

    ref
        .watch(latLngTempleProvider.select((value) => value.latLngTempleList))
        .forEach((element) {
      if (element.cnt > 0) {
        reachTempleNum++;
      }
    });
  }
}
