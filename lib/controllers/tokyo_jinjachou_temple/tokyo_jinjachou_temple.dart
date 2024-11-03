import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/tokyo_jinjachou_temple_model.dart';
import '../../utility/utility.dart';

part 'tokyo_jinjachou_temple.freezed.dart';

part 'tokyo_jinjachou_temple.g.dart';

@freezed
class TokyoJinjachouTempleState with _$TokyoJinjachouTempleState {
  const factory TokyoJinjachouTempleState({
    @Default(<TokyoJinjachouTempleModel>[]) List<TokyoJinjachouTempleModel> tokyoJinjachouTempleList,
    @Default(<String, dynamic>{}) Map<String, List<TokyoJinjachouTempleModel>> tokyoJinjachouTempleMap,
  }) = _TokyoJinjachouTempleState;
}

@riverpod
class TokyoJinjachouTemple extends _$TokyoJinjachouTemple {
  final Utility utility = Utility();

  ///
  @override
  TokyoJinjachouTempleState build() => const TokyoJinjachouTempleState();

  ///
  /// home_screen.dart
  Future<void> getTokyoJinjachouTemple() async {
    final HttpClient client = ref.read(httpClientProvider);

    // ignore: always_specify_types
    await client.post(path: APIPath.tokyoJinjachouTempleList).then((value) {
      final List<TokyoJinjachouTempleModel> list = <TokyoJinjachouTempleModel>[];
      final Map<String, List<TokyoJinjachouTempleModel>> map = <String, List<TokyoJinjachouTempleModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TokyoJinjachouTempleModel val =
            // ignore: avoid_dynamic_calls
            TokyoJinjachouTempleModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map[val.city] = <TokyoJinjachouTempleModel>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final TokyoJinjachouTempleModel val =
            // ignore: avoid_dynamic_calls
            TokyoJinjachouTempleModel.fromJson(value['data'][i] as Map<String, dynamic>);

        map[val.city]?.add(val);
      }

      state = state.copyWith(tokyoJinjachouTempleList: list, tokyoJinjachouTempleMap: map);
      // ignore: always_specify_types
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
