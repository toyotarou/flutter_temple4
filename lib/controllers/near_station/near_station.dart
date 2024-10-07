import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/near_station_model.dart';
import '../../utility/utility.dart';

part 'near_station.freezed.dart';

part 'near_station.g.dart';

@freezed
class NearStationState with _$NearStationState {
  const factory NearStationState({
    @Default(<NearStationResponseStationModel>[])
    List<NearStationResponseStationModel> nearStationList,
    @Default(<String, List<NearStationResponseStationModel>>{})
    Map<String, List<NearStationResponseStationModel>> nearStationNameMap,
    @Default(<String, List<NearStationResponseStationModel>>{})
    Map<String, List<NearStationResponseStationModel>> nearStationLineMap,
  }) = _NearStationState;
}

@riverpod
class NearStation extends _$NearStation {
  final Utility utility = Utility();

  ///
  @override
  NearStationState build() => const NearStationState();

  ///
  Future<void> getNearStation(
      {required String latitude, required String longitude}) async {
    final String url =
        'https://express.heartrails.com/api/json?method=getStations&x=$longitude&y=$latitude';

    final Response response = await get(Uri.parse(url));

    final NearStationModel result = nearStationModelFromJson(response.body);

    final List<NearStationResponseStationModel> list =
        <NearStationResponseStationModel>[];

    final Map<String, List<NearStationResponseStationModel>> map =
        <String, List<NearStationResponseStationModel>>{};

    final Map<String, List<NearStationResponseStationModel>> map2 =
        <String, List<NearStationResponseStationModel>>{};

    final List<String> stationNamesList = <String>[];

    for (int i = 0; i < result.response.station.length; i++) {
      final NearStationResponseStationModel val = result.response.station[i];

      if (!stationNamesList.contains(val.name)) {
        list.add(val);

        map[val.name] = <NearStationResponseStationModel>[];
      }

      map2[val.line] = <NearStationResponseStationModel>[];

      stationNamesList.add(val.name);
    }

    final List<String> stationNamesList2 = <String>[];

    for (int i = 0; i < result.response.station.length; i++) {
      final NearStationResponseStationModel val = result.response.station[i];

      if (!stationNamesList2.contains(val.name)) {
        map[val.name]?.add(val);
      }

      map2[val.line]?.add(val);

      stationNamesList2.add(val.name);
    }

    state = state.copyWith(
      nearStationList: list,
      nearStationNameMap: map,
      nearStationLineMap: map2,
    );
  }
}
