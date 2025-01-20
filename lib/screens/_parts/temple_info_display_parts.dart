import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/app_params/app_params_response_state.dart';
import '../../controllers/lat_lng_temple/lat_lng_temple.dart';
import '../../controllers/near_station/near_station.dart';
import '../../controllers/routing/routing.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/near_station_model.dart';
import '../../models/temple_model.dart';
import '../../models/tokyo_station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../_components/visited_temple_photo_alert.dart';
import '_temple_dialog.dart';

///
Widget templeInfoDisplayParts({
  required TempleData temple,
  required String from,
  required Map<String, List<String>> templeVisitDateMap,
  required Map<String, TempleModel> dateTempleMap,
  required List<TokyoTrainModel> tokyoTrainList,
  required BuildContext context,
  TokyoStationModel? station,
  required AppParamsResponseState appParamState,
  required WidgetRef ref,
}) {
  return DefaultTextStyle(
    style: const TextStyle(fontSize: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(width: context.screenSize.width),
        Text(temple.name),
        Text(temple.address),
        Text(temple.latitude),
        Text(temple.longitude),
        const SizedBox(height: 10),
        displayAddRemoveRoutingButton(from: from, ref: ref, temple: temple, station: station),
        const SizedBox(height: 10),
        displayNearStation(from: from, ref: ref, temple: temple),
        const SizedBox(height: 10),
        displayTempleVisitDate(from: from, temple: temple, context: context, templeVisitDateMap: templeVisitDateMap),
        const SizedBox(height: 10),
        displayVisitedTemplePhoto(
            context: context,
            from: from,
            templeVisitDateMap: templeVisitDateMap,
            temple: temple,
            dateTempleMap: dateTempleMap),
      ],
    ),
  );
}

///
Widget displayNearStation({required String from, required WidgetRef ref, required TempleData temple}) {
  if (from == 'LatLngTempleMapAlert' || from == 'NotReachTempleMapAlert') {
    final NearStationResponseStationModel? selectedNearStation =
        ref.watch(latLngTempleProvider.select((LatLngTempleState value) => value.selectedNearStation));
    //===================================//

    return ref
        .watch(
          nearStationProvider(
            latitude: temple.latitude,
            longitude: temple.longitude,
          ),
        )
        .when(
          data: (NearStationState value) {
            // ignore: always_specify_types
            final List<NearStationResponseStationModel> nsList = List.of(value.nearStationList);

            nsList.sort(
                (NearStationResponseStationModel a, NearStationResponseStationModel b) => a.name.compareTo(b.name));

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: nsList.map((NearStationResponseStationModel e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 5),
                  child: GestureDetector(
                    onTap: () => ref.read(latLngTempleProvider.notifier).setSelectedNearStation(station: e),
                    child: CircleAvatar(
                      backgroundColor: (selectedNearStation != null && e.name == selectedNearStation.name)
                          ? Colors.brown.withOpacity(0.8)
                          : Colors.brown.withOpacity(0.4),
                      child: Text(e.name, style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                );
              }).toList()),
            );
          },
          error: (Object error, StackTrace stackTrace) => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  } else {
    return Container();
  }
}

///
Widget displayAddRemoveRoutingButton(
    {required String from, required WidgetRef ref, required TempleData temple, TokyoStationModel? station}) {
  if (from != 'LatLngTempleMapAlert') {
    return Container();
  }

  final List<TempleData> routingTempleDataList =
      ref.watch(routingProvider.select((RoutingState value) => value.routingTempleDataList));

  final int pos = routingTempleDataList.indexWhere((TempleData element) => element.mark == temple.mark);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(),
      ElevatedButton(
        onPressed: () {
          ref.read(routingProvider.notifier).setRouting(templeData: temple, station: station);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: (pos != -1) ? Colors.white.withOpacity(0.2) : Colors.indigo.withOpacity(0.2)),
        child: Text((pos != -1) ? 'remove routing' : 'add routing'),
      ),
    ],
  );
}

///
Widget displayTempleVisitDate(
    {required String from,
    required TempleData temple,
    required BuildContext context,
    required Map<String, List<String>> templeVisitDateMap}) {
  if (from != 'VisitedTempleMapAlert') {
    return Container();
  }

  return SizedBox(
    height: 80,
    width: double.infinity,
    child: Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Wrap(
          children: templeVisitDateMap[temple.name]!.map((String e) {
            return Container(
              width: context.screenSize.width / 5,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              margin: const EdgeInsets.all(1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(e, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

///
Widget displayVisitedTemplePhoto(
    {required BuildContext context,
    required String from,
    required Map<String, List<String>> templeVisitDateMap,
    required TempleData temple,
    required Map<String, TempleModel> dateTempleMap}) {
  if (from != 'VisitedTempleMapAlert') {
    return Container();
  }

  return GestureDetector(
    onTap: () {
      TempleDialog(
        context: context,
        widget: VisitedTemplePhotoAlert(
            templeVisitDateMap: templeVisitDateMap, temple: temple, dateTempleMap: dateTempleMap),
        paddingTop: context.screenSize.height * 0.1,
        paddingLeft: context.screenSize.width * 0.2,
      );
    },
    child: const Icon(Icons.photo, color: Colors.white),
  );
}
