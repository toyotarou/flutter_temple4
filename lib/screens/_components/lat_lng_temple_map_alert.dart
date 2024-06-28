import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../state/lat_lng_temple/lat_lng_temple.dart';
import '../../state/routing/routing.dart';
import '../function.dart';
import '_temple_dialog.dart';
import 'temple_info_display_alert.dart';

class LatLngTempleMapAlert extends ConsumerStatefulWidget {
  const LatLngTempleMapAlert(
      {super.key, required this.templeList, this.station});

  final List<LatLngTempleModel> templeList;
  final TokyoStationModel? station;

  @override
  ConsumerState<LatLngTempleMapAlert> createState() =>
      _LatLngTempleDisplayAlertState();
}

class _LatLngTempleDisplayAlertState
    extends ConsumerState<LatLngTempleMapAlert> {
  List<TempleData> templeDataList = [];

  Map<String, double> boundsLatLngMap = {};

  double boundsInner = 0;

  List<Marker> markerList = [];

  List<int> reachedTempleIds = [];

  ///
  @override
  Widget build(BuildContext context) {
    templeDataList = [];

    widget.templeList.forEach((element) {
      templeDataList.add(
        TempleData(
          name: element.name,
          address: element.address,
          latitude: element.latitude,
          longitude: element.longitude,
          mark: element.id.toString(),
          cnt: element.cnt,
        ),
      );
    });

    if (widget.station != null) {
      templeDataList.add(TempleData(
        name: widget.station!.stationName,
        address: widget.station!.address,
        latitude: widget.station!.lat,
        longitude: widget.station!.lng,
        mark: '0',
        cnt: 0,
      ));
    }

    final boundsData = makeBounds(data: templeDataList);

    if (boundsData.isNotEmpty) {
      boundsLatLngMap = boundsData['boundsLatLngMap'];
      boundsInner = boundsData['boundsInner'];
    }

    makeMarker();

    return (boundsLatLngMap.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.station != null) ...[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.station!.stationName),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(latLngTempleProvider.notifier)
                                    .setOrangeDisplay();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Colors.orangeAccent.withOpacity(0.6),
                                radius: 10,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: context.screenSize.width,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.2)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: context.screenSize.height / 15,
                        ),
                        child: displaySelectedRoutingTemple(),
                      ),
                    ),
                  ],
                ),
              ],
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    bounds: LatLngBounds(
                      LatLng(
                        boundsLatLngMap['minLat']! - boundsInner,
                        boundsLatLngMap['minLng']! - boundsInner,
                      ),
                      LatLng(
                        boundsLatLngMap['maxLat']! + boundsInner,
                        boundsLatLngMap['maxLng']! + boundsInner,
                      ),
                    ),
                    minZoom: 10,
                    maxZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(markers: markerList),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  void makeMarker() {
    markerList = [];

    final orangeDisplay =
        ref.watch(latLngTempleProvider.select((value) => value.orangeDisplay));

    for (var i = 0; i < templeDataList.length; i++) {
      if (orangeDisplay) {
        if (templeDataList[i].cnt > 0) {
          continue;
        }
      }

      markerList.add(
        Marker(
          point: LatLng(
            templeDataList[i].latitude.toDouble(),
            templeDataList[i].longitude.toDouble(),
          ),
          builder: (context) {
            return GestureDetector(
              onTap: (templeDataList[i].mark == '0')
                  ? null
                  : () {
                      TempleDialog(
                        context: context,
                        widget: TempleInfoDisplayAlert(
                          temple: templeDataList[i],
                          from: 'LatLngTempleMapAlert',
                          station: widget.station,
                        ),
                        paddingTop: context.screenSize.height * 0.7,
                        clearBarrierColor: true,
                      );
                    },
              child: CircleAvatar(
                backgroundColor:
                    getCircleAvatarBgColor(element: templeDataList[i]),
                child: Text(
                  (templeDataList[i].mark == '0')
                      ? 'STA'
                      : templeDataList[i].mark.padLeft(3, '0'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget displaySelectedRoutingTemple() {
    final list = <Widget>[];

    var routingTempleDataList = ref
        .watch(routingProvider.select((value) => value.routingTempleDataList));

    for (var i = 1; i < routingTempleDataList.length; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          decoration: BoxDecoration(
            color: (routingTempleDataList[i].cnt > 0)
                ? Colors.pinkAccent.withOpacity(0.4)
                : Colors.orangeAccent.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            routingTempleDataList[i].mark,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      );
    }

    return (list.isNotEmpty)
        ? Wrap(children: list)
        : Text(
            'No Routing',
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          );
  }
}
