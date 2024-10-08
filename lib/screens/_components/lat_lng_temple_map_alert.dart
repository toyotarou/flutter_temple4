import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
import '../../controllers/routing/routing.dart';
import '../../controllers/temple/temple.dart';
import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/near_station_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/tile_provider.dart';
import '../_parts/_caution_dialog.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'goal_station_setting_alert.dart';
import 'route_display_setting_alert.dart';
import 'temple_info_display_alert.dart';

class LatLngTempleMapAlert extends ConsumerStatefulWidget {
  const LatLngTempleMapAlert({
    super.key,
    required this.templeList,
    this.station,
    required this.tokyoStationMap,
    required this.tokyoTrainList,
    required this.templeVisitDateMap,
    required this.dateTempleMap,
  });

  final List<LatLngTempleModel> templeList;
  final TokyoStationModel? station;
  final Map<String, TokyoStationModel> tokyoStationMap;
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<LatLngTempleMapAlert> createState() =>
      _LatLngTempleDisplayAlertState();
}

class _LatLngTempleDisplayAlertState
    extends ConsumerState<LatLngTempleMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  List<Marker> markerList = <Marker>[];

  List<int> reachedTempleIds = <int>[];

  MapController mapController = MapController();
  late LatLng currentCenter;

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
  void initState() {
    super.initState();

    currentCenter =
        LatLng(widget.station!.lat.toDouble(), widget.station!.lng.toDouble());
  }

  ///
  @override
  Widget build(BuildContext context) {
    final List<TempleData> routingTempleDataList = ref.watch(routingProvider
        .select((RoutingState value) => value.routingTempleDataList));

    //------------------// goal
    final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);

    final String goalStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.goalStationId));
    //------------------// goal

    templeDataList = <TempleData>[];

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    for (final LatLngTempleModel element in widget.templeList) {
      latList.add(double.parse(element.latitude));
      lngList.add(double.parse(element.longitude));

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
    }

    if (widget.station != null) {
      latList.add(double.parse(widget.station!.lat));
      lngList.add(double.parse(widget.station!.lng));

      templeDataList.add(TempleData(
        name: widget.station!.stationName,
        address: widget.station!.address,
        latitude: widget.station!.lat,
        longitude: widget.station!.lng,
        mark: 'STA',
      ));
    }

    if (tokyoTrainState.tokyoStationMap[goalStationId] != null) {
      final TokyoStationModel? goal =
          tokyoTrainState.tokyoStationMap[goalStationId];

      if (goal != null) {
        latList.add(double.parse(goal.lat));
        lngList.add(double.parse(goal.lng));
      }

      templeDataList.add(
        TempleData(
          name: goal!.stationName,
          address: goal.address,
          latitude: goal.lat,
          longitude: goal.lng,
          mark: goal.id,
        ),
      );
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }

    makeMarker();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.station != null) ...<Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 10),
              displayLatLngTempleMapButtonWidget(),
              Container(
                width: context.screenSize.width,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
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
                    PolylineLayer(
                      polylines: <Polyline<Object>>[
                        // ignore: always_specify_types
                        Polyline(
                          points: routingTempleDataList.map((TempleData e) {
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
                  ],
                );
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            IconButton(
              onPressed: () {
                mapController.move(currentCenter, 13);
              },
              icon: const Icon(
                Icons.center_focus_strong,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///
  Widget displayLatLngTempleMapButtonWidget() {
    final List<TempleData> routingTempleDataList = ref.watch(routingProvider
        .select((RoutingState value) => value.routingTempleDataList));

    //------------------// goal
    final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);

    final String goalStationId = ref.watch(
        routingProvider.select((RoutingState value) => value.goalStationId));
    //------------------// goal

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[900]!.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      widget.station!.stationName,
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (routingTempleDataList.length < 2) {
                          caution_dialog(
                            context: context,
                            content: 'cant setting goal',
                          );

                          return;
                        }

                        TempleDialog(
                          context: context,
                          widget: GoalStationSettingAlert(
                            tokyoStationMap: widget.tokyoStationMap,
                            tokyoTrainList: widget.tokyoTrainList,
                          ),
                          paddingLeft: context.screenSize.width * 0.2,
                          clearBarrierColor: true,
                        );
                      },
                      child: Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Goal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        (tokyoTrainState.tokyoStationMap[goalStationId] != null)
                            ? tokyoTrainState
                                .tokyoStationMap[goalStationId]!.stationName
                            : '-----',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(routingProvider.notifier).removeGoalStation();
                      },
                      child:
                          const Icon(Icons.close, color: Colors.purpleAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              TempleDialog(
                context: context,
                widget: RouteDisplaySettingAlert(),
                paddingLeft: context.screenSize.width * 0.1,
              );
            },
            child: const Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              ref.read(latLngTempleProvider.notifier).setOrangeDisplay();
            },
            child: CircleAvatar(
              backgroundColor: Colors.orangeAccent.withOpacity(0.6),
              radius: 10,
            ),
          ),
        ],
      ),
    );
  }

  ///
  void makeMarker() {
    markerList = <Marker>[];

    final bool orangeDisplay = ref.watch(latLngTempleProvider
        .select((LatLngTempleState value) => value.orangeDisplay));

    for (int i = 0; i < templeDataList.length; i++) {
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
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: (templeDataList[i].mark == '0')
                ? null
                : () {
                    final int exMarkLength =
                        templeDataList[i].mark.split('-').length;

                    if (exMarkLength == 2) {
                      return;
                    } else {
                      ref.read(templeProvider.notifier).setSelectTemple(
                            name: templeDataList[i].name,
                            lat: templeDataList[i].latitude,
                            lng: templeDataList[i].longitude,
                          );

                      TempleDialog(
                        context: context,
                        widget: TempleInfoDisplayAlert(
                          temple: templeDataList[i],
                          from: 'LatLngTempleMapAlert',
                          station: widget.station,
                          templeVisitDateMap: widget.templeVisitDateMap,
                          dateTempleMap: widget.dateTempleMap,
                        ),
                        paddingTop: context.screenSize.height * 0.6,
                        clearBarrierColor: true,
                      );
                    }
                  },
            child: CircleAvatar(
              backgroundColor:
                  getCircleAvatarBgColor(element: templeDataList[i], ref: ref),
              child: getCircleAvatarText(element: templeDataList[i]),
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
                backgroundColor: Colors.brown.withOpacity(0.5),
                child: const Text(''),
              ),
            ),
          ),
        );
      }
    }
  }

  ///
  Widget getCircleAvatarText({required TempleData element}) {
    final List<TempleData> routingTempleDataList = ref.watch(routingProvider
        .select((RoutingState value) => value.routingTempleDataList));

    String str = '';
    if (element.mark == '0') {
      str = 'S';
    } else if (element.mark.split('-').length == 2) {
      if (routingTempleDataList.isNotEmpty &&
          routingTempleDataList[0].name == element.name) {
        str = 'S';
      } else {
        str = 'G';
      }
    } else {
      str = element.mark.padLeft(3, '0');
    }

    return Text(
      str,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }

  ///
  Widget displaySelectedRoutingTemple() {
    final List<Widget> list = <Widget>[];

    final List<TempleData> routingTempleDataList = ref.watch(routingProvider
        .select((RoutingState value) => value.routingTempleDataList));

    for (int i = 1; i < routingTempleDataList.length; i++) {
      final String distance = calcDistance(
        originLat: routingTempleDataList[i - 1].latitude.toDouble(),
        originLng: routingTempleDataList[i - 1].longitude.toDouble(),
        destLat: routingTempleDataList[i].latitude.toDouble(),
        destLng: routingTempleDataList[i].longitude.toDouble(),
      );

      list.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: 40,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white)),
              ),
              alignment: Alignment.topRight,
              child: Text(distance,
                  style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              decoration: (routingTempleDataList[i].mark.split('-').length != 2)
                  ? BoxDecoration(
                      color: (routingTempleDataList[i].cnt > 0)
                          ? Colors.pinkAccent.withOpacity(0.5)
                          : Colors.orangeAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: (routingTempleDataList[i].mark.split('-').length != 2)
                  ? Text(routingTempleDataList[i].mark,
                      style: const TextStyle(fontSize: 10, color: Colors.white))
                  : const Text(''),
            ),
          ],
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
