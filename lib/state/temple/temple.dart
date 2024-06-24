import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_model.dart';
import '../../utility/utility.dart';

part 'temple.freezed.dart';

part 'temple.g.dart';

@freezed
class TempleState with _$TempleState {
  const factory TempleState({
    @Default([]) List<TempleModel> templeList,
    @Default({}) Map<String, TempleModel> templeMap,

    ///
    @Default('') String searchWord,
    @Default(false) bool doSearch,
  }) = _TempleState;
}

@riverpod
class Temple extends _$Temple {
  final utility = Utility();

  ///
  @override
  TempleState build() => const TempleState();

  ///
  Future<void> getAllTemple() async {
    final client = ref.read(httpClientProvider);

    await client.post(path: APIPath.getAllTemple).then((value) {
      final list = <TempleModel>[];
      final map = <String, TempleModel>{};

      // ignore: avoid_dynamic_calls
      for (var i = 0; i < value['list'].length.toString().toInt(); i++) {
        final val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.date.yyyymmdd] = val;
      }

      state = state.copyWith(templeList: list, templeMap: map);
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }

  ///
  Future<void> doSearch({required String searchWord}) async =>
      state = state.copyWith(searchWord: searchWord, doSearch: true);

  ///
  Future<void> clearSearch() async =>
      state = state.copyWith(searchWord: '', doSearch: false);
}
