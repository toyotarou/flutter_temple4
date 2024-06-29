import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_temple4/state/temple_lat_lng/temple_lat_lng.dart';

import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../state/temple/temple.dart';
import '../_parts/_temple_dialog.dart';
import 'visited_temple_map_alert.dart';

class VisitedTempleListAlert extends ConsumerStatefulWidget {
  const VisitedTempleListAlert({super.key});

  @override
  ConsumerState<VisitedTempleListAlert> createState() =>
      _VisitedTempleListAlertState();
}

class _VisitedTempleListAlertState
    extends ConsumerState<VisitedTempleListAlert> {
  ///
  @override
  void initState() {
    super.initState();

    ref.read(templeProvider.notifier).getAllTemple();

    ref.read(templeLatLngProvider.notifier).getAllTempleLatLng();
  }

  ///
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Expanded(child: displayTempleList()),
          ],
        ),
      ),
    );
  }

  Widget displayTempleList() {
    final list = <Widget>[];

    final templeLatLngMap = ref
        .watch(templeLatLngProvider.select((value) => value.templeLatLngMap));

    final templeState = ref.watch(templeProvider);

    final roopList = List<TempleModel>.from(templeState.templeList);

    var keepYm = '';
    roopList.forEach((element) {
      if (keepYm != element.date.yyyymm) {
        list.add(
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                stops: const [0.7, 1],
              ),
            ),
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(5),
            child: Text(element.date.yyyymm),
          ),
        );
      }

      list.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element.temple,
                      style: TextStyle(
                        color: (templeState.selectTempleName == element.temple)
                            ? Colors.yellowAccent
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      element.date.yyyymmdd,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(templeProvider.notifier).setSelectTemple(
                        name: element.temple,
                        lat: (templeLatLngMap[element.temple] != null)
                            ? templeLatLngMap[element.temple]!.lat
                            : '',
                        lng: (templeLatLngMap[element.temple] != null)
                            ? templeLatLngMap[element.temple]!.lng
                            : '',
                      );

                  Navigator.pop(context);
                  Navigator.pop(context);

                  TempleDialog(
                    context: context,
                    widget: const VisitedTempleMapAlert(),
                    clearBarrierColor: true,
                  );
                },
                child: Icon(
                  Icons.location_on,
                  color: (templeState.selectTempleName == element.temple)
                      ? Colors.yellowAccent.withOpacity(0.4)
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      );

      if (element.memo != '') {
        element.memo.split('、').forEach((element2) {
          list.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element2,
                          style: TextStyle(
                            color: (templeState.selectTempleName == element2)
                                ? Colors.yellowAccent
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          element.date.yyyymmdd,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(templeProvider.notifier).setSelectTemple(
                            name: element2,
                            lat: (templeLatLngMap[element2] != null)
                                ? templeLatLngMap[element2]!.lat
                                : '',
                            lng: (templeLatLngMap[element2] != null)
                                ? templeLatLngMap[element2]!.lng
                                : '',
                          );

                      Navigator.pop(context);
                      Navigator.pop(context);

                      TempleDialog(
                        context: context,
                        widget: const VisitedTempleMapAlert(),
                        clearBarrierColor: true,
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: (templeState.selectTempleName == element2)
                          ? Colors.yellowAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }

      keepYm = element.date.yyyymm;
    });

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ),
      ),
    );
  }
}
