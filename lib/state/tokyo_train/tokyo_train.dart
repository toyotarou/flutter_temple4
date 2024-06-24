import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/tokyo_train_model.dart';
import '../../utility/utility.dart';

part 'tokyo_train.freezed.dart';

part 'tokyo_train.g.dart';

@freezed
class TokyoTrainState with _$TokyoTrainState {
  const factory TokyoTrainState({
    @Default([]) List<TokyoTrainModel> tokyoTrainList,
    @Default({}) Map<String, TokyoTrainModel> tokyoTrainMap,
    @Default({}) Map<String, TokyoTrainModel> tokyoTrainIdMap,
  }) = _TokyoTrainState;
}

@riverpod
class TokyoTrain extends _$TokyoTrain {
  final utility = Utility();

  ///
  @override
  TokyoTrainState build() => const TokyoTrainState();

  ///
  Future<void> getTokyoTrain() async {
    final client = ref.read(httpClientProvider);

    await client.post(path: APIPath.getTokyoTrainStation).then((value) {
      final list = <TokyoTrainModel>[];
      final map = <String, TokyoTrainModel>{};
      final idMap = <String, TokyoTrainModel>{};

      // ignore: avoid_dynamic_calls
      for (var i = 0; i < value['data'].length.toString().toInt(); i++) {
        final val = TokyoTrainModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.trainName] = val;

        idMap[val.trainNumber.toString()] = val;
      }

      state = state.copyWith(tokyoTrainList: list, tokyoTrainMap: map);
    }).catchError((error, _) {
      utility.showError('予期せぬエラーが発生しました');
    });
  }
}
