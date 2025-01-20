// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_params_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamsResponseState {
// DateTime? calendarSelectedDate,
// GeolocModel? selectedTimeGeoloc,
// @Default(true) bool isMarkerShow,
// @Default('') String selectedHour,
  double get currentZoom => throw _privateConstructorUsedError;
  int get currentPaddingIndex =>
      throw _privateConstructorUsedError; // LatLng? currentCenter,
// @Default(false) bool isTempleCircleShow,
// GeolocModel? polylineGeolocModel,
// TempleInfoModel? selectedTemple,
// @Default(-1) int timeGeolocDisplayStart,
// @Default(-1) int timeGeolocDisplayEnd,
  List<OverlayEntry>? get bigEntries => throw _privateConstructorUsedError;
  void Function(void Function())? get setStateCallback =>
      throw _privateConstructorUsedError;
  Offset? get overlayPosition => throw _privateConstructorUsedError;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamsResponseStateCopyWith<AppParamsResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamsResponseStateCopyWith<$Res> {
  factory $AppParamsResponseStateCopyWith(AppParamsResponseState value,
          $Res Function(AppParamsResponseState) then) =
      _$AppParamsResponseStateCopyWithImpl<$Res, AppParamsResponseState>;
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      List<OverlayEntry>? bigEntries,
      void Function(void Function())? setStateCallback,
      Offset? overlayPosition});
}

/// @nodoc
class _$AppParamsResponseStateCopyWithImpl<$Res,
        $Val extends AppParamsResponseState>
    implements $AppParamsResponseStateCopyWith<$Res> {
  _$AppParamsResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? bigEntries = freezed,
    Object? setStateCallback = freezed,
    Object? overlayPosition = freezed,
  }) {
    return _then(_value.copyWith(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      bigEntries: freezed == bigEntries
          ? _value.bigEntries
          : bigEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      setStateCallback: freezed == setStateCallback
          ? _value.setStateCallback
          : setStateCallback // ignore: cast_nullable_to_non_nullable
              as void Function(void Function())?,
      overlayPosition: freezed == overlayPosition
          ? _value.overlayPosition
          : overlayPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamsResponseStateImplCopyWith<$Res>
    implements $AppParamsResponseStateCopyWith<$Res> {
  factory _$$AppParamsResponseStateImplCopyWith(
          _$AppParamsResponseStateImpl value,
          $Res Function(_$AppParamsResponseStateImpl) then) =
      __$$AppParamsResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentZoom,
      int currentPaddingIndex,
      List<OverlayEntry>? bigEntries,
      void Function(void Function())? setStateCallback,
      Offset? overlayPosition});
}

/// @nodoc
class __$$AppParamsResponseStateImplCopyWithImpl<$Res>
    extends _$AppParamsResponseStateCopyWithImpl<$Res,
        _$AppParamsResponseStateImpl>
    implements _$$AppParamsResponseStateImplCopyWith<$Res> {
  __$$AppParamsResponseStateImplCopyWithImpl(
      _$AppParamsResponseStateImpl _value,
      $Res Function(_$AppParamsResponseStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentZoom = null,
    Object? currentPaddingIndex = null,
    Object? bigEntries = freezed,
    Object? setStateCallback = freezed,
    Object? overlayPosition = freezed,
  }) {
    return _then(_$AppParamsResponseStateImpl(
      currentZoom: null == currentZoom
          ? _value.currentZoom
          : currentZoom // ignore: cast_nullable_to_non_nullable
              as double,
      currentPaddingIndex: null == currentPaddingIndex
          ? _value.currentPaddingIndex
          : currentPaddingIndex // ignore: cast_nullable_to_non_nullable
              as int,
      bigEntries: freezed == bigEntries
          ? _value._bigEntries
          : bigEntries // ignore: cast_nullable_to_non_nullable
              as List<OverlayEntry>?,
      setStateCallback: freezed == setStateCallback
          ? _value.setStateCallback
          : setStateCallback // ignore: cast_nullable_to_non_nullable
              as void Function(void Function())?,
      overlayPosition: freezed == overlayPosition
          ? _value.overlayPosition
          : overlayPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ));
  }
}

/// @nodoc

class _$AppParamsResponseStateImpl implements _AppParamsResponseState {
  const _$AppParamsResponseStateImpl(
      {this.currentZoom = 0,
      this.currentPaddingIndex = 5,
      final List<OverlayEntry>? bigEntries,
      this.setStateCallback,
      this.overlayPosition})
      : _bigEntries = bigEntries;

// DateTime? calendarSelectedDate,
// GeolocModel? selectedTimeGeoloc,
// @Default(true) bool isMarkerShow,
// @Default('') String selectedHour,
  @override
  @JsonKey()
  final double currentZoom;
  @override
  @JsonKey()
  final int currentPaddingIndex;
// LatLng? currentCenter,
// @Default(false) bool isTempleCircleShow,
// GeolocModel? polylineGeolocModel,
// TempleInfoModel? selectedTemple,
// @Default(-1) int timeGeolocDisplayStart,
// @Default(-1) int timeGeolocDisplayEnd,
  final List<OverlayEntry>? _bigEntries;
// LatLng? currentCenter,
// @Default(false) bool isTempleCircleShow,
// GeolocModel? polylineGeolocModel,
// TempleInfoModel? selectedTemple,
// @Default(-1) int timeGeolocDisplayStart,
// @Default(-1) int timeGeolocDisplayEnd,
  @override
  List<OverlayEntry>? get bigEntries {
    final value = _bigEntries;
    if (value == null) return null;
    if (_bigEntries is EqualUnmodifiableListView) return _bigEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final void Function(void Function())? setStateCallback;
  @override
  final Offset? overlayPosition;

  @override
  String toString() {
    return 'AppParamsResponseState(currentZoom: $currentZoom, currentPaddingIndex: $currentPaddingIndex, bigEntries: $bigEntries, setStateCallback: $setStateCallback, overlayPosition: $overlayPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamsResponseStateImpl &&
            (identical(other.currentZoom, currentZoom) ||
                other.currentZoom == currentZoom) &&
            (identical(other.currentPaddingIndex, currentPaddingIndex) ||
                other.currentPaddingIndex == currentPaddingIndex) &&
            const DeepCollectionEquality()
                .equals(other._bigEntries, _bigEntries) &&
            (identical(other.setStateCallback, setStateCallback) ||
                other.setStateCallback == setStateCallback) &&
            (identical(other.overlayPosition, overlayPosition) ||
                other.overlayPosition == overlayPosition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentZoom,
      currentPaddingIndex,
      const DeepCollectionEquality().hash(_bigEntries),
      setStateCallback,
      overlayPosition);

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => __$$AppParamsResponseStateImplCopyWithImpl<
          _$AppParamsResponseStateImpl>(this, _$identity);
}

abstract class _AppParamsResponseState implements AppParamsResponseState {
  const factory _AppParamsResponseState(
      {final double currentZoom,
      final int currentPaddingIndex,
      final List<OverlayEntry>? bigEntries,
      final void Function(void Function())? setStateCallback,
      final Offset? overlayPosition}) = _$AppParamsResponseStateImpl;

// DateTime? calendarSelectedDate,
// GeolocModel? selectedTimeGeoloc,
// @Default(true) bool isMarkerShow,
// @Default('') String selectedHour,
  @override
  double get currentZoom;
  @override
  int get currentPaddingIndex; // LatLng? currentCenter,
// @Default(false) bool isTempleCircleShow,
// GeolocModel? polylineGeolocModel,
// TempleInfoModel? selectedTemple,
// @Default(-1) int timeGeolocDisplayStart,
// @Default(-1) int timeGeolocDisplayEnd,
  @override
  List<OverlayEntry>? get bigEntries;
  @override
  void Function(void Function())? get setStateCallback;
  @override
  Offset? get overlayPosition;

  /// Create a copy of AppParamsResponseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
