import 'dart:math';

//import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/temple/temple.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'temple_course_display_alert.dart';
import 'temple_photo_gallery_alert.dart';

class TempleDetailMapAlert extends ConsumerStatefulWidget {
  const TempleDetailMapAlert(
      {super.key,
      required this.date,
      required this.templeLatLngMap,
      required this.stationMap});

  final DateTime date;
  final Map<String, TempleLatLngModel> templeLatLngMap;
  final Map<String, StationModel> stationMap;

  @override
  ConsumerState<TempleDetailMapAlert> createState() =>
      _TempleDetailDialogState();
}

class _TempleDetailDialogState extends ConsumerState<TempleDetailMapAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  List<Marker> markerList = <Marker>[];

  List<Polyline<Object>> polylineList = <Polyline<Object>>[];

  Utility utility = Utility();

  String start = '';
  String end = '';

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
    makeTempleDataList();

    makeMarker();

    makeStartEnd();

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
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
                        initialCenter: LatLng(minLat, minLng),
                        initialCameraFit:
                            ((minLat == maxLat) && (minLng == maxLng))
                                ? null
                                : CameraFit.bounds(
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
                              points: templeDataList.map((TempleData e) {
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
          ],
        ),
        displayInfoPlate(),
      ],
    );
  }

  ///
  Widget displayInfoPlate() {
    final Map<String, TempleModel> dateTempleMap = ref.watch(
        templeProvider.select((TempleState value) => value.dateTempleMap));

    final TempleModel? temple = dateTempleMap[widget.date.yyyymmdd];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              TempleDialog(
                context: context,
                widget: TempleCourseDisplayAlert(data: templeDataList),
                paddingLeft: context.screenSize.width * 0.2,
                clearBarrierColor: true,
              );
            },
            icon: const Icon(
              Icons.info_outline,
              size: 30,
              color: Colors.white,
            ),
          ),
          if (temple == null)
            Container()
          else
            DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.date.yyyymmdd),
                  Text(temple.temple),
                  const SizedBox(height: 10),
                  Text(start),
                  Text(end),
                  if (temple.memo != '') ...<Widget>[
                    const SizedBox(height: 10),
                    Flexible(
                      child: SizedBox(
                        width: context.screenSize.width * 0.6,
                        child: Text(temple.memo),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  displayThumbNailPhoto(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ///
  Widget displayThumbNailPhoto() {
    final Map<String, TempleModel> dateTempleMap = ref.watch(
        templeProvider.select((TempleState value) => value.dateTempleMap));

    final TempleModel? temple = dateTempleMap[widget.date.yyyymmdd];

    final List<Widget> list = <Widget>[];

    if (temple != null) {
      if (temple.photo.isNotEmpty) {
        for (int i = 0; i < temple.photo.length; i++) {
          list.add(
            GestureDetector(
              onTap: () {
                TempleDialog(
                  context: context,
                  widget: TemplePhotoGalleryAlert(
                    photoList: temple.photo,
                    number: i,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: 50,
                // child: CachedNetworkImage(
                //   imageUrl: temple.photo[i],
                //   placeholder: (context, url) =>
                //       Image.asset('assets/images/no_image.png'),
                //   errorWidget: (context, url, error) => const Icon(Icons.error),
                // ),

                child: Image.network(temple.photo[i]),
              ),
            ),
          );
        }
      }
    }

    return SizedBox(
      width: context.screenSize.width * 0.6,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: list)),
    );
  }

  ///
  void makeTempleDataList() {
    templeDataList = <TempleData>[];

    final List<double> latList = <double>[];
    final List<double> lngList = <double>[];

    final Map<String, TempleModel> dateTempleMap = ref.watch(
        templeProvider.select((TempleState value) => value.dateTempleMap));

    final TempleModel? temple = dateTempleMap[widget.date.yyyymmdd];

    if (temple != null) {
      getStartEndPointInfo(temple: temple, flag: 'start');

      if (widget.templeLatLngMap[temple.temple] != null) {
        latList.add(double.parse(widget.templeLatLngMap[temple.temple]!.lat));
        lngList.add(double.parse(widget.templeLatLngMap[temple.temple]!.lng));

        templeDataList.add(
          TempleData(
            name: temple.temple,
            address: widget.templeLatLngMap[temple.temple]!.address,
            latitude: widget.templeLatLngMap[temple.temple]!.lat,
            longitude: widget.templeLatLngMap[temple.temple]!.lng,
            mark: '01',
          ),
        );
      }

      if (temple.memo != '') {
        int i = 2;
        temple.memo.split('、').forEach((String element) {
          final TempleLatLngModel? latlng = widget.templeLatLngMap[element];

          if (latlng != null) {
            latList.add(double.parse(latlng.lat));
            lngList.add(double.parse(latlng.lng));

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

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  Future<void> getStartEndPointInfo(
      {required TempleModel temple, required String flag}) async {
    String point = '';
    switch (flag) {
      case 'start':
        point = temple.startPoint;
      case 'end':
        point = temple.endPoint;
    }

    if (widget.stationMap[point] != null) {
      templeDataList.add(
        TempleData(
          name: widget.stationMap[point]!.stationName,
          address: widget.stationMap[point]!.address,
          latitude: widget.stationMap[point]!.lat,
          longitude: widget.stationMap[point]!.lng,
          mark: (flag == 'end')
              ? (temple.startPoint == temple.endPoint)
                  ? 'S/E'
                  : 'E'
              : (temple.startPoint == temple.endPoint)
                  ? 'S/E'
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
                  : (temple.startPoint == temple.endPoint)
                      ? 'S/E'
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
                  : (temple.startPoint == temple.endPoint)
                      ? 'S/E'
                      : 'S',
            ),
          );
      }
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
          child: CircleAvatar(
            backgroundColor:
                getCircleAvatarBgColor(element: templeDataList[i], ref: ref),
            child: Text(
              templeDataList[i].mark,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  ///
  void makeStartEnd() {
    if (templeDataList.isNotEmpty) {
      final Iterable<TempleData> sWhere = templeDataList.where(
          (TempleData element) => element.mark == 'S' || element.mark == 'S/E');
      if (sWhere.isNotEmpty) {
        start = sWhere.first.name;
      }

      final Iterable<TempleData> eWhere = templeDataList.where(
          (TempleData element) => element.mark == 'E' || element.mark == 'S/E');

      if (eWhere.isNotEmpty) {
        end = eWhere.first.name;
      }
    }

    setState(() {});
  }
}
