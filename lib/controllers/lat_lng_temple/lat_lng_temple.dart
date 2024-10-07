import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/lat_lng_temple_model.dart';
import '../../models/near_station_model.dart';
import '../../utility/utility.dart';

part 'lat_lng_temple.freezed.dart';

part 'lat_lng_temple.g.dart';

@freezed
class LatLngTempleState with _$LatLngTempleState {
  const factory LatLngTempleState({
    @Default(<LatLngTempleModel>[]) List<LatLngTempleModel> latLngTempleList,
    @Default(<String, LatLngTempleModel>{})
    Map<String, LatLngTempleModel> latLngTempleMap,
    @Default(false) bool listSorting,
    @Default(false) bool orangeDisplay,
    NearStationResponseStationModel? selectedNearStation,
  }) = _LatLngTempleState;
}

@riverpod
class LatLngTemple extends _$LatLngTemple {
  final Utility utility = Utility();

  ///
  @override
  LatLngTempleState build() => const LatLngTempleState();

  ///
  Future<void> getLatLngTemple({required Map<String, String> param}) async {
    final HttpClient client = ref.read(httpClientProvider);

    await client.post(
      path: APIPath.getLatLngTemple,
      body: <String, dynamic>{
        'latitude': param['latitude'],
        'longitude': param['longitude'],
        'radius': 10
      },
      // ignore: always_specify_types
    ).then((value) {
      final List<LatLngTempleModel> list = <LatLngTempleModel>[];
      final Map<String, LatLngTempleModel> map = <String, LatLngTempleModel>{};

      // ignore: avoid_dynamic_calls, always_specify_types
      final id = (value['data'][0] as Map<String, dynamic>)['id'];

      if (id != '88888888') {
        // ignore: avoid_dynamic_calls
        for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
          final LatLngTempleModel val = LatLngTempleModel.fromJson(
            // ignore: avoid_dynamic_calls
            value['data'][i] as Map<String, dynamic>,
          );

          list.add(val);
          map[val.name] = val;
        }
      }

      state = state.copyWith(latLngTempleList: list, latLngTempleMap: map);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }

  ///
  Future<void> toggleListSorting() async {
    final bool listSorting = state.listSorting;
    state = state.copyWith(listSorting: !listSorting);
  }

  ///
  Future<void> setOrangeDisplay() async {
    final bool orangeDisplay = state.orangeDisplay;
    state = state.copyWith(orangeDisplay: !orangeDisplay);
  }

  ///
  Future<void> setSelectedNearStation(
      {required NearStationResponseStationModel station}) async {
    state = state.copyWith(selectedNearStation: station);
  }

  ///
  Future<void> clearSelectedNearStation() async {
    state = state.copyWith(selectedNearStation: null);
  }
}
