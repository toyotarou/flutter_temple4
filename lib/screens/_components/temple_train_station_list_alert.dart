import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_temple4/screens/_components/_temple_dialog.dart';
import 'package:flutter_temple4/screens/_components/temple_not_reach_station_list_alert.dart';

import '../../extensions/extensions.dart';
import '../../state/temple_list/temple_list.dart';
import '../../state/tokyo_train/tokyo_train.dart';

class TempleTrainStationListAlert extends ConsumerStatefulWidget {
  const TempleTrainStationListAlert({super.key});

  @override
  ConsumerState<TempleTrainStationListAlert> createState() =>
      _TempleTrainListAlertState();
}

class _TempleTrainListAlertState
    extends ConsumerState<TempleTrainStationListAlert> {
  ///
  @override
  void initState() {
    super.initState();

    ref.read(tokyoTrainProvider.notifier).getTokyoTrain();

    ref.read(templeListProvider.notifier).getAllTempleListTemple();

    ref.read(templeNotReachListProvider.notifier).getAllNotReachTemple();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final tokyoTrainList =
        ref.watch(tokyoTrainProvider.select((value) => value.tokyoTrainList));

    final searchStationId =
        ref.watch(templeListProvider.select((value) => value.searchStationId));

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _displayStationTempleCount(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        TempleDialog(
                          context: context,
                          widget: const TempleNotReachStationListAlert(),
                        );
                      },
                      icon: Icon(
                        Icons.train,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    IconButton(
                      onPressed: (searchStationId == '') ? null : () {},
                      icon: Icon(
                        Icons.map,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tokyoTrainList.map((e) {
                    return ExpansionTile(
                      title: Text(e.trainName),
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
                                color: (e2.id == searchStationId)
                                    ? Colors.yellowAccent
                                    : Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e2.stationName),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(templeListProvider.notifier)
                                        .setSearchStationId(id: e2.id);
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: (e2.id == searchStationId)
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
  Widget _displayStationTempleCount() {
    final templeListState = ref.watch(templeListProvider);

    final templeNotReachStationMap = ref.watch(
        templeNotReachListProvider.select((value) => value.templeStationMap));

    if (templeListState.searchStationId == '') {
      return Text(templeListState.templeListList.length.toString());
    }

    var totalNum = 0;
    var notReachNum = 0;
    if (templeListState.templeStationMap[templeListState.searchStationId] !=
        null) {
      totalNum = templeListState
          .templeStationMap[templeListState.searchStationId]!.length;

      if (templeNotReachStationMap[templeListState.searchStationId] != null) {
        notReachNum =
            templeNotReachStationMap[templeListState.searchStationId]!.length;
      }
    }

    return Row(
      children: [
        Text('Total : $totalNum'),
        const SizedBox(width: 20),
        Text('Not Reach : $notReachNum'),
      ],
    );
  }
}
