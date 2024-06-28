import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../state/routing/routing.dart';
import '../../state/tokyo_train/tokyo_train.dart';

class GoalStationSettingAlert extends ConsumerStatefulWidget {
  const GoalStationSettingAlert({super.key});

  @override
  ConsumerState<GoalStationSettingAlert> createState() =>
      _GoalStationSettingAlertState();
}

class _GoalStationSettingAlertState
    extends ConsumerState<GoalStationSettingAlert> {
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

    final goalStationId =
        ref.watch(routingProvider.select((value) => value.goalStationId));

    final startStationId =
        ref.watch(routingProvider.select((value) => value.startStationId));

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
                              fontSize: 12,
                              color: (e2.id == goalStationId)
                                  ? Colors.yellowAccent
                                  : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e2.stationName),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(routingProvider.notifier)
                                        .setGoalStationId(id: e2.id);

                                    final station =
                                        tokyoTrainState.tokyoStationMap[e2.id];

                                    ref
                                        .read(routingProvider.notifier)
                                        .setRouting(
                                          templeData: TempleData(
                                            name: (station != null)
                                                ? station.stationName
                                                : '',
                                            address: (station != null)
                                                ? station.address
                                                : '',
                                            latitude: (station != null)
                                                ? station.lat
                                                : '',
                                            longitude: (station != null)
                                                ? station.lng
                                                : '',
                                            mark: (station != null)
                                                ? station.id
                                                : '',
                                            cnt: 0,
                                          ),
                                          station: tokyoTrainState
                                              .tokyoStationMap[startStationId],
                                        );

//                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    color: (e2.id == goalStationId)
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
}
