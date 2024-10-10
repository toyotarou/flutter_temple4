import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_list_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';

class NotReachTempleStationListAlert extends ConsumerStatefulWidget {
  const NotReachTempleStationListAlert(
      {super.key,
      required this.tokyoTrainList,
      required this.templeStationMap});

  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<TempleListModel>> templeStationMap;

  @override
  ConsumerState<NotReachTempleStationListAlert> createState() =>
      _TempleNotReachStationListAlertState();
}

class _TempleNotReachStationListAlertState
    extends ConsumerState<NotReachTempleStationListAlert> {
  List<String> notReachTrainIds = <String>[];
  List<String> notReachStationIds = <String>[];

  ///
  @override
  Widget build(BuildContext context) {
    makeNotReachTempleIds();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Expanded(child: displayNotReachTrain()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayNotReachTrain() {
    final List<Widget> list = <Widget>[];

    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      if (notReachTrainIds.contains(element.trainNumber.toString())) {
        list.add(
          ExpansionTile(
            collapsedIconColor: Colors.white,
            title: Text(
              element.trainName,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            children: element.station.map((TokyoStationModel e2) {
              if (notReachStationIds.contains(e2.id)) {
                return displayNotReachStation(data: e2);
              } else {
                return Container();
              }
            }).toList(),
          ),
        );
      } else {
        list.add(Container());
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Widget displayNotReachStation({required TokyoStationModel data}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            data.stationName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            (widget.templeStationMap[data.id] != null)
                ? widget.templeStationMap[data.id]!.length.toString()
                : '0',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  ///
  void makeNotReachTempleIds() {
    widget.templeStationMap.forEach((String key, List<TempleListModel> value) {
      notReachTrainIds.add(key.split('-')[0]);

      notReachStationIds.add(key);
    });
  }
}
