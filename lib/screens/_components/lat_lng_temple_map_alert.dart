import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_temple4/screens/_components/lat_lng_temple_list_alert.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../function.dart';
import '_temple_dialog.dart';
import 'temple_detail_map_alert.dart';
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        TempleDialog(
                          context: context,
                          widget: LatLngTempleListAlert(),
                          paddingLeft: context.screenSize.width * 0.2,
                          clearBarrierColor: true,
                        );
                      },
                      icon: const Icon(Icons.list),
                    ),
                    Text(widget.station!.stationName),
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

    for (var i = 0; i < templeDataList.length; i++) {
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
                        widget:
                            TempleInfoDisplayAlert(temple: templeDataList[i]),
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
}
