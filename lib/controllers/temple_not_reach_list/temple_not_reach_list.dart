import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_list_model.dart';
import '../../utility/utility.dart';

part 'temple_not_reach_list.freezed.dart';

part 'temple_not_reach_list.g.dart';

@freezed
class TempleNotReachListState with _$TempleNotReachListState {
  const factory TempleNotReachListState({
    @Default(<TempleListModel>[]) List<TempleListModel> templeListList,
    @Default(<String, TempleListModel>{})
    Map<String, TempleListModel> templeListMap,
    @Default(<String, List<TempleListModel>>{})
    Map<String, List<TempleListModel>> templeStationMap,
  }) = _TempleNotReachListState;
}

@riverpod
class TempleNotReachList extends _$TempleNotReachList {
  final Utility utility = Utility();

  ///
  @override
  TempleNotReachListState build() => const TempleNotReachListState();

  ///
  Future<void> getAllNotReachTemple() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.templeNotReached).then((value) {
      final List<TempleListModel> list = <TempleListModel>[];
      final Map<String, TempleListModel> map = <String, TempleListModel>{};
      final Map<String, List<TempleListModel>> templeStationMap =
          <String, List<TempleListModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TempleListModel val = TempleListModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.name] = val;

        val.nearStation.split(',').forEach((String element) {
          templeStationMap[element.trim()] = <TempleListModel>[];
        });
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TempleListModel val = TempleListModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        val.nearStation.split(',').forEach((String element) {
          templeStationMap[element.trim()]?.add(val);
        });
      }

      state = state.copyWith(
        templeListList: list,
        templeListMap: map,
        templeStationMap: templeStationMap,
      );
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
