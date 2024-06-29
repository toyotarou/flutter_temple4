import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/common/temple_data.dart';
import '../../models/tokyo_station_model.dart';
import '../../utility/utility.dart';

part 'routing.freezed.dart';

part 'routing.g.dart';

@freezed
class RoutingState with _$RoutingState {
  const factory RoutingState({
    @Default([]) List<TempleData> routingTempleDataList,
    @Default({}) Map<String, TempleData> routingTempleDataMap,

    ///
    @Default('') String startStationId,
    @Default('') String goalStationId,
  }) = _RoutingState;
}

@riverpod
class Routing extends _$Routing {
  final utility = Utility();

  ///
  @override
  RoutingState build() => const RoutingState();

  ///
  Future<void> setRouting(
      {required TempleData templeData, TokyoStationModel? station}) async {
    final list = [...state.routingTempleDataList];

    if (list.isEmpty) {
      if (station != null) {
        final stationTempleData = TempleData(
          name: station.stationName,
          address: station.address,
          latitude: station.lat,
          longitude: station.lng,
          mark: station.id,
        );

        list.add(stationTempleData);
      }
    }

    if (station?.stationName == templeData.name) {
      if (list.last.mark.split('-').length == 2) {
        list.removeAt(list.length - 1);
      }
    } else {
      final markList = <String>[];
      list.forEach((element) => markList.add(element.mark));

      final pos = markList.indexWhere((element) => element == templeData.mark);

      if (pos != -1) {
        list.removeAt(pos);
      } else {
        list.add(templeData);
      }
    }

    if (station?.stationName != templeData.name) {
      if (templeData.mark.split('-').length == 2) {
        list[list.length - 1] = templeData;
      }
    }

    state = state.copyWith(routingTempleDataList: list);
  }

  ///
  Future<void> clearRoutingTempleDataList() async {
    state = state.copyWith(routingTempleDataList: []);
  }

  ///
  Future<void> setStartStationId({required String id}) async =>
      state = state.copyWith(startStationId: id);

  ///
  Future<void> setGoalStationId({required String id}) async =>
      state = state.copyWith(goalStationId: id);
}
