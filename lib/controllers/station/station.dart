import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/station_model.dart';
import '../../utility/utility.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
class StationState with _$StationState {
  const factory StationState({
    @Default(<StationModel>[]) List<StationModel> stationList,
    @Default(<String, StationModel>{}) Map<String, StationModel> stationMap,
  }) = _StationState;
}

@riverpod
class Station extends _$Station {
  final Utility utility = Utility();

  ///
  @override
  StationState build() => const StationState();

  ///
  Future<void> getAllStation() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.getAllStation).then((value) {
      final List<StationModel> list = <StationModel>[];
      final Map<String, StationModel> map = <String, StationModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final StationModel val = StationModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.id.toString()] = val;
      }

      state = state.copyWith(stationList: list, stationMap: map);
    // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}