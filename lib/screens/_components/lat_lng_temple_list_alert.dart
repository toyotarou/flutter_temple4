import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../state/lat_lng_temple/lat_lng_temple.dart';
import '../function.dart';
import 'temple_detail_map_alert.dart';

class LatLngTempleListAlert extends ConsumerStatefulWidget {
  const LatLngTempleListAlert({super.key});

  @override
  ConsumerState<LatLngTempleListAlert> createState() =>
      _LatLngTempleListAlertState();
}

class _LatLngTempleListAlertState extends ConsumerState<LatLngTempleListAlert> {
  @override
  Widget build(BuildContext context) {
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
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(latLngTempleProvider.notifier)
                              .setOrangeDisplay();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.orangeAccent.withOpacity(0.6),
                          radius: 10,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(latLngTempleProvider.notifier)
                              .toggleListSorting();
                        },
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 3,
              ),
              Expanded(child: displayLatLngTempleList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayLatLngTempleList() {
    final list = <Widget>[];

    final listSorting =
        ref.watch(latLngTempleProvider.select((value) => value.listSorting));

    final latLngTempleState = ref.watch(latLngTempleProvider);

    final roopList = List.from(latLngTempleState.latLngTempleList);

    if (listSorting) {
      roopList.sort((a, b) {
        // ignore: avoid_dynamic_calls
        return a.id.compareTo(b.id);
      });
    }

    for (var i = 0; i < roopList.length; i++) {
      if (latLngTempleState.orangeDisplay) {
        if (roopList[i].cnt > 0) {
          continue;
        }
      }

      list.add(Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: getCircleAvatarBgColor(
                  element: TempleData(
                    name: roopList[i].name,
                    address: roopList[i].address,
                    latitude: roopList[i].latitude,
                    longitude: roopList[i].longitude,
                    mark: roopList[i].id.toString(),
                    cnt: roopList[i].cnt,
                  ),
                ),
                child: Text(
                  roopList[i].id.toString().padLeft(3, '0'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(roopList[i].name),
                    Text(roopList[i].address),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(roopList[i].dist),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.check),
            ],
          ),
          const Divider(color: Colors.white),
        ],
      ));
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
