import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
import '../../controllers/not_reach_station_line_count/not_reach_station_line_count.dart';
import '../../controllers/routing/routing.dart';
import '../../controllers/temple/temple.dart';
import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/not_reach_station_line_count_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../_parts/_caution_dialog.dart';
import '../_parts/_temple_dialog.dart';
import 'lat_lng_temple_map_alert.dart';
import 'not_reach_temple_station_list_alert.dart';

class TempleTrainStationListAlert extends ConsumerStatefulWidget {
  const TempleTrainStationListAlert({
    super.key,
    required this.tokyoStationMap,
    required this.tokyoTrainList,
    required this.templeStationMap,
    required this.templeVisitDateMap,
    required this.dateTempleMap,
    required this.tokyoTrainIdMap,
  });

  final Map<String, TokyoStationModel> tokyoStationMap;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<TempleListModel>> templeStationMap;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;
  final Map<int, TokyoTrainModel> tokyoTrainIdMap;

  @override
  ConsumerState<TempleTrainStationListAlert> createState() =>
      _TempleTrainListAlertState();
}

class _TempleTrainListAlertState
    extends ConsumerState<TempleTrainStationListAlert> {
  int reachTempleNum = 0;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                children: <Widget>[
                  displaySelectedStation(),
                  displayTempleTrainStationListButton(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: displayTokyoTrainList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTempleTrainStationListButton() {
    final String startStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.startStationId));

    final List<LatLngTempleModel> latLngTempleList = ref.watch(
        latLngTempleProvider
            .select((LatLngTempleState value) => value.latLngTempleList));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                TempleDialog(
                  context: context,
                  widget: NotReachTempleStationListAlert(
                    tokyoTrainList: widget.tokyoTrainList,
                    templeStationMap: widget.templeStationMap,
                  ),
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
                        caution_dialog(context: context, content: 'no hit');

                        return;
                      }

                      ref
                          .read(routingProvider.notifier)
                          .clearRoutingTempleDataList();

                      ref
                          .read(routingProvider.notifier)
                          .setGoalStationId(id: '');

                      ref
                          .read(latLngTempleProvider.notifier)
                          .clearSelectedNearStation();

                      ref
                          .read(templeProvider.notifier)
                          .setSelectTemple(name: '', lat: '', lng: '');

                      ref.read(tokyoTrainProvider.notifier).clearTrainList();

                      TempleDialog(
                        context: context,
                        widget: LatLngTempleMapAlert(
                          templeList: latLngTempleList,
                          station: widget.tokyoStationMap[startStationId],
                          tokyoStationMap: widget.tokyoStationMap,
                          tokyoTrainList: widget.tokyoTrainList,
                          templeVisitDateMap: widget.templeVisitDateMap,
                          dateTempleMap: widget.dateTempleMap,
                          tokyoTrainIdMap: widget.tokyoTrainIdMap,
                        ),
                      );
                    },
              icon: Icon(
                Icons.map,
                color: (startStationId != '' && latLngTempleList.isNotEmpty)
                    ? Colors.yellowAccent.withOpacity(0.4)
                    : Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  Widget displaySelectedStation() {
    final String startStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.startStationId));

    final List<LatLngTempleModel> latLngTempleList = ref.watch(
        latLngTempleProvider
            .select((LatLngTempleState value) => value.latLngTempleList));

    getReachTempleNum();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          (widget.tokyoStationMap[startStationId] != null)
              ? widget.tokyoStationMap[startStationId]!.stationName
              : '-----',
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(latLngTempleList.length.toString()),
            Text(reachTempleNum.toString()),
            Text(
              (latLngTempleList.length - reachTempleNum).toString(),
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          ],
        ),
      ],
    );
  }

  ///
  Widget displayTokyoTrainList() {
    final List<Widget> list = <Widget>[];

    final String startStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.startStationId));

    final Map<String, NotReachLineCountModel> notReachLineCountMap = ref.watch(
        notReachStationLineCountProvider.select(
            (NotReachStationLineCountState value) =>
                value.notReachLineCountMap));

    final Map<String, NotReachStationCountModel> notReachStationCountMap =
        ref.watch(notReachStationLineCountProvider.select(
            (NotReachStationLineCountState value) =>
                value.notReachStationCountMap));

    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      list.add(
        ExpansionTile(
          collapsedIconColor: Colors.white,
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          title: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  element.trainName,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                Text(
                  (notReachLineCountMap[element.trainName]?.count ?? 0)
                      .toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: (notReachLineCountMap[element.trainName] != null)
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          children: element.station.map((TokyoStationModel e2) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
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
                  children: <Widget>[
                    Text(e2.stationName),
                    Row(
                      children: <Widget>[
                        Text(
                          (notReachStationCountMap[e2.stationName]?.count ?? 0)
                              .toString(),
                          style: TextStyle(
                            color: (notReachStationCountMap[e2.stationName] !=
                                    null)
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(latLngTempleProvider.notifier)
                                .getLatLngTemple(param: <String, String>{
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
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
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
  void getReachTempleNum() {
    reachTempleNum = 0;

    ref
        .watch(latLngTempleProvider
            .select((LatLngTempleState value) => value.latLngTempleList))
        .forEach((LatLngTempleModel element) {
      if (element.cnt > 0) {
        reachTempleNum++;
      }
    });
  }
}
