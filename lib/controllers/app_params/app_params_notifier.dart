import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_params_response_state.dart';

final AutoDisposeStateNotifierProvider<AppParamNotifier, AppParamsResponseState> appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
        (AutoDisposeStateNotifierProviderRef<AppParamNotifier, AppParamsResponseState> ref) {
  return AppParamNotifier(const AppParamsResponseState());
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  ///
  void setTempleGeolocTimeCircleAvatarParams({
    required List<OverlayEntry>? bigEntries,
    required void Function(VoidCallback fn)? setStateCallback,
  }) {
    state = state.copyWith(bigEntries: bigEntries, setStateCallback: setStateCallback);
  }

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);
}
