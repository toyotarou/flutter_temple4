import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/near_station/near_station.dart';
import '../../controllers/routing/routing.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/near_station_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'visited_temple_photo_alert.dart';

class TempleInfoDisplayAlert extends ConsumerStatefulWidget {
  const TempleInfoDisplayAlert(
      {super.key,
      required this.temple,
      required this.from,
      this.station,
      required this.templeVisitDateMap,
      required this.dateTempleMap,
      required this.tokyoTrainList});

  final TempleData temple;
  final String from;
  final TokyoStationModel? station;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;
  final List<TokyoTrainModel> tokyoTrainList;

  @override
  ConsumerState<TempleInfoDisplayAlert> createState() =>
      _TempleInfoDisplayAlertState();
}

class _TempleInfoDisplayAlertState
    extends ConsumerState<TempleInfoDisplayAlert> {
  Map<String, TokyoStationModel> tokyoStationNameMap =
      <String, TokyoStationModel>{};

  ///
  @override
  void initState() {
    super.initState();

    if (widget.from == 'LatLngTempleMapAlert') {
      ref.read(nearStationProvider.notifier).getNearStation(
          latitude: widget.temple.latitude, longitude: widget.temple.longitude);
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeTokyoStationNameMap();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              displayTempleInfo(),
              displayAddRemoveRoutingButton(),
              const SizedBox(height: 10),
              displayNearStation(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void makeTokyoStationNameMap() {
    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      for (final TokyoStationModel element2 in element.station) {
        tokyoStationNameMap[element2.stationName] = element2;
      }
    }
  }

  ///
  Widget displayAddRemoveRoutingButton() {
    if (widget.from != 'LatLngTempleMapAlert') {
      return Container();
    }

    final List<TempleData> routingTempleDataList = ref.watch(routingProvider
        .select((RoutingState value) => value.routingTempleDataList));

    final int pos = routingTempleDataList
        .indexWhere((TempleData element) => element.mark == widget.temple.mark);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(),
        ElevatedButton(
          onPressed: () {
            ref
                .read(routingProvider.notifier)
                .setRouting(templeData: widget.temple, station: widget.station);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: (pos != -1)
                  ? Colors.white.withOpacity(0.2)
                  : Colors.indigo.withOpacity(0.2)),
          child: Text((pos != -1) ? 'remove routing' : 'add routing'),
        ),
      ],
    );
  }

  ///
  Widget displayTempleInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        displayTempleInfoCircleAvatar(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),
              Text(widget.temple.name),
              Text(widget.temple.address),
              Text(widget.temple.latitude),
              Text(widget.temple.longitude),
              const SizedBox(height: 10),
              displayTempleVisitDate(),
            ],
          ),
        ),
        displayVisitedTemplePhoto(),
      ],
    );
  }

  ///
  Widget displayVisitedTemplePhoto() {
    if (widget.from != 'VisitedTempleMapAlert') {
      return Row(
        children: <Widget>[Container(), const SizedBox(width: 20)],
      );
    }

    return GestureDetector(
      onTap: () {
        TempleDialog(
          context: context,
          widget: VisitedTemplePhotoAlert(
            templeVisitDateMap: widget.templeVisitDateMap,
            temple: widget.temple,
            dateTempleMap: widget.dateTempleMap,
          ),
          paddingTop: context.screenSize.height * 0.1,
          paddingLeft: context.screenSize.width * 0.2,
        );
      },
      child: const Icon(Icons.photo, color: Colors.white),
    );
  }

  ///
  Widget displayTempleInfoCircleAvatar() {
    if (widget.from == 'VisitedTempleMapAlert') {
      return Row(
        children: <Widget>[Container(), const SizedBox(width: 20)],
      );
    }

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor:
              getCircleAvatarBgColor(element: widget.temple, ref: ref),
          child: Text(
            widget.temple.mark.padLeft(2, '0'),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  ///
  Widget displayTempleVisitDate() {
    if (widget.from != 'VisitedTempleMapAlert') {
      return Container();
    }

    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Wrap(
            children:
                widget.templeVisitDateMap[widget.temple.name]!.map((String e) {
              return Container(
                width: context.screenSize.width / 5,
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                margin: const EdgeInsets.all(1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(e, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayNearStation() {
    if (widget.from != 'LatLngTempleMapAlert') {
      return Container();
    }

    final List<NearStationResponseStationModel> nearStationList = ref.watch(
        nearStationProvider
            .select((NearStationState value) => value.nearStationList));

    return Wrap(
        children: nearStationList.map((NearStationResponseStationModel e) {
      return Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 5),
        child: GestureDetector(
          onTap: () {
            print(tokyoStationNameMap[e.name]);
          },
          child: CircleAvatar(
            backgroundColor: Colors.purple.withOpacity(0.2),
            child: Text(e.name, style: const TextStyle(fontSize: 10)),
          ),
        ),
      );
    }).toList());
  }
}
