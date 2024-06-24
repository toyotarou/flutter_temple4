import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../state/temple_list/temple_list.dart';
import '../../state/tokyo_train/tokyo_train.dart';

class TempleNotReachStationListAlert extends ConsumerStatefulWidget {
  const TempleNotReachStationListAlert({super.key});

  @override
  ConsumerState<TempleNotReachStationListAlert> createState() =>
      _TempleNotReachStationListAlertState();
}

class _TempleNotReachStationListAlertState
    extends ConsumerState<TempleNotReachStationListAlert> {
  List<String> notReachTrainIds = [];
  List<String> notReachStationIds = [];

  ///
  @override
  void initState() {
    super.initState();

    ref.read(tokyoTrainProvider.notifier).getTokyoTrain();

    ref.read(templeNotReachListProvider.notifier).getAllNotReachTemple();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final tokyoTrainList =
        ref.watch(tokyoTrainProvider.select((value) => value.tokyoTrainList));

    final templeStationMap = ref.watch(
        templeNotReachListProvider.select((value) => value.templeStationMap));

    makeNotReachTempleIds();

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: tokyoTrainList.map((e) {
                    if (notReachTrainIds.contains(e.trainNumber.toString())) {
                      return ExpansionTile(
                        title: Text(e.trainName),
                        children: e.station.map((e2) {
                          if (notReachStationIds.contains(e2.id)) {
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e2.stationName),
                                  Text((templeStationMap[e2.id] != null)
                                      ? templeStationMap[e2.id]!
                                          .length
                                          .toString()
                                      : '0'),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makeNotReachTempleIds() {
    ref
        .watch(templeNotReachListProvider
            .select((value) => value.templeStationMap))
        .forEach((key, value) {
      notReachTrainIds.add(key.split('-')[0]);

      notReachStationIds.add(key);
    });
  }
}
