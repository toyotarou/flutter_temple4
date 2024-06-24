import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../state/station/station.dart';
import '../../state/temple/temple.dart';
import '../../state/temple_lat_lng/temple_lat_lng.dart';
import '../../utility/utility.dart';

class TempleDetailAlert extends ConsumerStatefulWidget {
  const TempleDetailAlert({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<TempleDetailAlert> createState() => _TempleDetailDialogState();
}

class _TempleDetailDialogState extends ConsumerState<TempleDetailAlert> {
  List<TempleData> templeDataList = [];

  Map<String, double> boundsLatLngMap = {};

  double boundsInner = 0;

  List<Marker> markerList = [];

  List<Polyline> polylineList = [];

//  MapboxpolylinePoints mapboxpolylinePoints = MapboxpolylinePoints();

  Utility utility = Utility();

  ///
  @override
  void initState() {
    super.initState();

    ref.read(templeLatLngProvider.notifier).getAllTempleLatLng();

    ref.read(stationProvider.notifier).getAllStation();
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeTempleDataList();

    makeBounds();

    makeMarker();

    return Stack(
      children: [
        (boundsLatLngMap.isNotEmpty)
            ? FlutterMap(
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
                  // minZoom: 8,
                  // maxZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: templeDataList.map((e) {
                          return LatLng(
                            e.latitude.toDouble(),
                            e.longitude.toDouble(),
                          );
                        }).toList(),
                        color: Colors.redAccent,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                  MarkerLayer(markers: markerList),
                ],
              )
            : Container(),
      ],
    );
  }

  ///
  void makeTempleDataList() {
    templeDataList = [];

    final templeMap =
        ref.watch(templeProvider.select((value) => value.templeMap));

    final templeLatLngMap = ref
        .watch(templeLatLngProvider.select((value) => value.templeLatLngMap));

    final temple = templeMap[widget.date.yyyymmdd];

    if (temple != null) {
      getStartEndPointInfo(temple: temple, flag: 'start');

      if (templeLatLngMap[temple.temple] != null) {
        templeDataList.add(
          TempleData(
            name: temple.temple,
            address: templeLatLngMap[temple.temple]!.address,
            latitude: templeLatLngMap[temple.temple]!.lat,
            longitude: templeLatLngMap[temple.temple]!.lng,
            mark: '01',
          ),
        );
      }

      if (temple.memo != '') {
        var i = 2;
        temple.memo.split('、').forEach((element) {
          final latlng = templeLatLngMap[element];

          if (latlng != null) {
            templeDataList.add(
              TempleData(
                name: element,
                address: latlng.address,
                latitude: latlng.lat,
                longitude: latlng.lng,
                mark: i.toString().padLeft(2, '0'),
              ),
            );
          }

          i++;
        });
      }

      getStartEndPointInfo(temple: temple, flag: 'end');
    }
  }

  ///
  Future<void> getStartEndPointInfo(
      {required TempleModel temple, required String flag}) async {
    final stationMap =
        ref.watch(stationProvider.select((value) => value.stationMap));

    var point = '';
    switch (flag) {
      case 'start':
        point = temple.startPoint;
        break;
      case 'end':
        point = temple.endPoint;
        break;
    }

    if (stationMap[point] != null) {
      templeDataList.add(
        TempleData(
          name: stationMap[point]!.stationName,
          address: stationMap[point]!.address,
          latitude: stationMap[point]!.lat,
          longitude: stationMap[point]!.lng,
          mark: (flag == 'end')
              ? (temple.startPoint == temple.endPoint)
                  ? 'S/E'
                  : 'E'
              : 'S',
        ),
      );
    } else {
      switch (point) {
        case '自宅':
          templeDataList.add(
            TempleData(
              name: point,
              address: '千葉県船橋市二子町492-25-101',
              latitude: '35.7102009',
              longitude: '139.9490672',
              mark: (flag == 'end')
                  ? (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'E'
                  : 'S',
            ),
          );

        case '実家':
          templeDataList.add(
            TempleData(
              name: point,
              address: '東京都杉並区善福寺4-22-11',
              latitude: '35.7185071',
              longitude: '139.5869534',
              mark: (flag == 'end')
                  ? (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'E'
                  : 'S',
            ),
          );
      }
    }
  }

  ///
  void makeBounds() {
    final latList = <double>[];
    final lngList = <double>[];

    templeDataList.forEach((element) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
    });

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      final minLat = latList.reduce(min);
      final maxLat = latList.reduce(max);
      final minLng = lngList.reduce(min);
      final maxLng = lngList.reduce(max);

      final latDiff = maxLat - minLat;
      final lngDiff = maxLng - minLng;
      final small = (latDiff < lngDiff) ? latDiff : lngDiff;
      boundsInner = small;

      boundsLatLngMap = {
        'minLat': minLat,
        'maxLat': maxLat,
        'minLng': minLng,
        'maxLng': maxLng,
      };
    }

    setState(() {});
  }

  ///
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
            return CircleAvatar(
              backgroundColor:
                  getCircleAvatarBgColor(element: templeDataList[i]),
              child: Text(templeDataList[i].mark,
              style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      );
    }
  }

  ///
  Color? getCircleAvatarBgColor({required TempleData element}) {
    switch (element.mark) {
      case 'S':
      case 'E':
      case 'S/E':
        return Colors.green[900];
      case '01':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }
}

class TempleData {
  TempleData({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mark,
  });

  String name;
  String address;
  String latitude;
  String longitude;
  String mark;
}
