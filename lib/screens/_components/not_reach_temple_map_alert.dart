import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/near_station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'not_reach_temple_train_select_alert.dart';
import 'temple_info_display_alert.dart';

class NotReachTempleMapAlert extends ConsumerStatefulWidget {
  const NotReachTempleMapAlert(
      {super.key,
      required this.templeLatLngList,
      required this.tokyoTrainIdMap,
      required this.templeListList,
      required this.tokyoTrainList,
      required this.templeVisitDateMap,
      required this.dateTempleMap});

  final List<TempleLatLngModel> templeLatLngList;
  final Map<int, TokyoTrainModel> tokyoTrainIdMap;
  final List<TempleListModel> templeListList;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<NotReachTempleMapAlert> createState() =>
      _NotReachTempleMapAlertState();
}

class _NotReachTempleMapAlertState
    extends ConsumerState<NotReachTempleMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  List<Marker> markerList = <Marker>[];

  List<Polyline<Object>> polylineList = <Polyline<Object>>[];

  Utility utility = Utility();

  final MapController mapController = MapController();

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  bool firstMapDisplay = false;

  ///
  Future<void> _loadMapTiles() async {
    // ignore: always_specify_types
    return Future.delayed(Duration(seconds: firstMapDisplay ? 0 : 2));
  }

  ///
  @override
  Widget build(BuildContext context) {
    getNotReachTemple();

    makePolylineList();

    makeMarker();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  templeDataList.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    TempleDialog(
                      context: context,
                      widget: NotReachTempleTrainSelectAlert(
                        tokyoTrainList: widget.tokyoTrainList,
                      ),
                      paddingRight: context.screenSize.width * 0.2,
                      clearBarrierColor: true,
                    );
                  },
                  icon: const Icon(Icons.train, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: _loadMapTiles(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading map'));
                } else {
                  firstMapDisplay = true;

                  return FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCameraFit: CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(
                          <LatLng>[
                            LatLng(minLat, maxLng),
                            LatLng(maxLat, minLng)
                          ],
                        ),
                        padding: const EdgeInsets.all(50),
                      ),
                    ),
                    children: <Widget>[
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: CachedTileProvider(),
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: markerList),
                      // ignore: always_specify_types
                      PolylineLayer(polylines: polylineList),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ///
  void getNotReachTemple() {
    templeDataList = <TempleData>[];

    final List<String> jogaiTempleNameList = <String>[];
    final List<String> jogaiTempleAddressList = <String>[];
    final List<String> jogaiTempleAddressList2 = <String>[];

    for (final TempleLatLngModel element in widget.templeLatLngList) {
      jogaiTempleNameList.add(element.temple);
      jogaiTempleAddressList.add(element.address);
      jogaiTempleAddressList2.add('東京都${element.address}');
    }

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    for (int i = 0; i < widget.templeListList.length; i++) {
      if (jogaiTempleNameList.contains(widget.templeListList[i].name)) {
        continue;
      }

      if (jogaiTempleAddressList.contains(widget.templeListList[i].address)) {
        continue;
      }

      if (jogaiTempleAddressList2.contains(widget.templeListList[i].address)) {
        continue;
      }

      if (jogaiTempleAddressList
          .contains('東京都${widget.templeListList[i].address}')) {
        continue;
      }

      if (jogaiTempleAddressList2
          .contains('東京都${widget.templeListList[i].address}')) {
        continue;
      }

      latList.add(double.parse(widget.templeListList[i].lat));
      lngList.add(double.parse(widget.templeListList[i].lng));

      templeDataList.add(
        TempleData(
          name: widget.templeListList[i].name,
          address: widget.templeListList[i].address,
          latitude: widget.templeListList[i].lat,
          longitude: widget.templeListList[i].lng,
          mark: widget.templeListList[i].id.toString(),
        ),
      );
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  void makeMarker() {
    markerList = <Marker>[];

    for (int i = 0; i < templeDataList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(
            templeDataList[i].latitude.toDouble(),
            templeDataList[i].longitude.toDouble(),
          ),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              TempleDialog(
                context: context,
                widget: TempleInfoDisplayAlert(
                  temple: templeDataList[i],
                  from: 'NotReachTempleMapAlert',
                  templeVisitDateMap: widget.templeVisitDateMap,
                  dateTempleMap: widget.dateTempleMap,
                ),
                paddingTop: context.screenSize.height * 0.6,
                clearBarrierColor: true,
              );
            },
            child: CircleAvatar(
              backgroundColor:
                  getCircleAvatarBgColor(element: templeDataList[i], ref: ref),
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
          ),
        ),
      );
    }

    final NearStationResponseStationModel? selectedNearStation = ref.watch(
        latLngTempleProvider
            .select((LatLngTempleState value) => value.selectedNearStation));

    if (selectedNearStation != null) {
      if (selectedNearStation.y > 0 && selectedNearStation.x > 0) {
        markerList.add(
          Marker(
            point: LatLng(selectedNearStation.y, selectedNearStation.x),
            width: 40,
            height: 40,
            child: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.purple.withOpacity(0.5),
                child: const Text(''),
              ),
            ),
          ),
        );
      }
    }
  }

  ///
  void makePolylineList() {
    polylineList = <Polyline<Object>>[];

    final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);

    final List<LatLng> points = <LatLng>[];

    for (int i = 0; i < tokyoTrainState.selectTrainList.length; i++) {
      final TokyoTrainModel? map =
          widget.tokyoTrainIdMap[tokyoTrainState.selectTrainList[i]];

      map?.station.forEach((TokyoStationModel element2) =>
          points.add(LatLng(element2.lat.toDouble(), element2.lng.toDouble())));

      polylineList.add(
        // ignore: always_specify_types
        Polyline(points: points, color: Colors.redAccent, strokeWidth: 5),
      );
    }
  }
}
