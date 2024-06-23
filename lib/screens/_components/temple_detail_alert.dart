import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../state/station/station.dart';
import '../../state/temple/temple.dart';
import '../../state/temple_lat_lng/temple_lat_lng.dart';

class TempleDetailAlert extends ConsumerStatefulWidget {
  const TempleDetailAlert({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<TempleDetailAlert> createState() => _TempleDetailDialogState();
}

class _TempleDetailDialogState extends ConsumerState<TempleDetailAlert> {
  List<TempleData> templeDataList = [];

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

    print(templeDataList);

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: templeDataList.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e.mark == 'end') ...[
                            const Divider(color: Colors.white)
                          ],
                          Text(e.name),
                          Text(e.address),
                          Text(e.latitude),
                          Text(e.longitude),
                          Text(e.mark),
                          const SizedBox(height: 30),
                          if (e.mark == 'start') ...[
                            const Divider(color: Colors.white)
                          ],
                        ],
                      );
                    }).toList()),
              ),
            ),
          ],
        ),
      ),
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
            mark: 'main',
          ),
        );
      }

      if (temple.memo != '') {
        temple.memo.split('、').forEach((element) {
          final latlng = templeLatLngMap[element];

          if (latlng != null) {
            templeDataList.add(
              TempleData(
                name: element,
                address: latlng.address,
                latitude: latlng.lat,
                longitude: latlng.lng,
                mark: 'sub',
              ),
            );
          }
        });
      }

      getStartEndPointInfo(temple: temple, flag: 'end');
    }
  }

  ///
  Future<void> getStartEndPointInfo(
      {required TempleModel temple, required String flag}) async {
    var stationMap =
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
          mark: flag,
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
              mark: flag,
            ),
          );

        case '実家':
          templeDataList.add(
            TempleData(
              name: point,
              address: '東京都杉並区善福寺4-22-11',
              latitude: '35.7185071',
              longitude: '139.5869534',
              mark: flag,
            ),
          );
      }
    }
  }
}

class TempleData {
  String name;
  String address;
  String latitude;
  String longitude;
  String mark;

  TempleData({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mark,
  });
}
