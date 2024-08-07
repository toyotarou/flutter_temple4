import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';
import '../../state/temple/temple.dart';
import '../_parts/_temple_dialog.dart';
import '../function.dart';
import 'temple_info_display_alert.dart';
import 'visited_temple_list_alert.dart';

class VisitedTempleMapAlert extends ConsumerStatefulWidget {
  const VisitedTempleMapAlert(
      {super.key,
      required this.templeLatLngMap,
      required this.templeList,
      required this.templeVisitDateMap,
      required this.dateTempleMap});

  final Map<String, TempleLatLngModel> templeLatLngMap;
  final List<TempleModel> templeList;
  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, TempleModel> dateTempleMap;

  @override
  ConsumerState<VisitedTempleMapAlert> createState() =>
      _VisitedTempleMapAlertState();
}

class _VisitedTempleMapAlertState extends ConsumerState<VisitedTempleMapAlert> {
  List<TempleData> templeDataList = [];

  Map<String, double> boundsLatLngMap = {};

  double boundsInner = 0;

  List<Marker> markerList = [];

  ///
  @override
  void initState() {
    super.initState();

    ref.read(templeProvider.notifier).getAllTemple();
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeTempleDataList();

    final boundsData = makeBounds(data: templeDataList);

    if (boundsData.isNotEmpty) {
      boundsLatLngMap = boundsData['boundsLatLngMap'];
      boundsInner = boundsData['boundsInner'];
    }

    makeMarker();

    final templeState = ref.watch(templeProvider);

    return (boundsLatLngMap.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        TempleDialog(
                          context: context,
                          widget: VisitedTempleListAlert(
                            templeLatLngMap: widget.templeLatLngMap,
                            templeList: widget.templeList,
                            templeVisitDateMap: widget.templeVisitDateMap,




                              dateTempleMap:widget.dateTempleMap,




                          ),
                          paddingLeft: context.screenSize.width * 0.1,
                        );
                      },
                      icon: const Icon(Icons.list, color: Colors.white),
                    ),
                    if (templeState.selectTempleName != '') ...[
                      IconButton(
                        onPressed: () {
                          ref
                              .read(templeProvider.notifier)
                              .setSelectTemple(name: '', lat: '', lng: '');

                          Navigator.pop(context);

                          TempleDialog(
                            context: context,
                            widget: VisitedTempleMapAlert(
                              templeLatLngMap: widget.templeLatLngMap,
                              templeList: widget.templeList,
                              templeVisitDateMap: widget.templeVisitDateMap,
                              dateTempleMap: widget.dateTempleMap,
                            ),
                            clearBarrierColor: true,
                          );
                        },
                        icon: const Icon(Icons.map, color: Colors.white),
                      ),
                    ],
                    if (templeState.selectTempleName == '') ...[Container()],
                  ],
                ),
              ),
              Expanded(
                child: FlutterMap(
                  options: (templeState.selectTempleName != '')
                      ? MapOptions(
                          center: LatLng(
                            templeState.selectTempleLat.toString().toDouble(),
                            templeState.selectTempleLng.toString().toDouble(),
                          ),
                          zoom: 16,
                          maxZoom: 17,
                          minZoom: 3,
                        )
                      : MapOptions(
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

  ///
  void makeTempleDataList() {
    templeDataList = [];

    final templeNamesList = <String>[];

    widget.templeList
      ..forEach((element) {
        templeNamesList.add(element.temple);
      })
      ..forEach((element) {
        if (element.memo != '') {
          element.memo.split('、').forEach((element2) {
            if (!templeNamesList.contains(element2)) {
              templeNamesList.add(element2);
            }
          });
        }
      });

    templeNamesList.forEach((element) {
      final temple = widget.templeLatLngMap[element];

      if (temple != null) {
        templeDataList.add(
          TempleData(
            name: temple.temple,
            address: temple.address,
            latitude: temple.lat,
            longitude: temple.lng,
          ),
        );
      }
    });
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
            return GestureDetector(
              onTap: (templeDataList[i].mark == '0')
                  ? null
                  : () {
                      ref.read(templeProvider.notifier).setSelectTemple(
                            name: templeDataList[i].name,
                            lat: templeDataList[i].latitude,
                            lng: templeDataList[i].longitude,
                          );

                      TempleDialog(
                        context: context,
                        widget: TempleInfoDisplayAlert(
                          temple: templeDataList[i],
                          from: 'VisitedTempleMapAlert',
                          templeVisitDateMap: widget.templeVisitDateMap,
                          dateTempleMap: widget.dateTempleMap,
                        ),
                        paddingTop: context.screenSize.height * 0.6,
                        clearBarrierColor: true,
                      );
                    },
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent.withOpacity(0.5),
                child: const Text('', style: TextStyle(fontSize: 10)),
              ),
            );
          },
        ),
      );
    }
  }
}
