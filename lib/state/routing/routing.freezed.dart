// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RoutingState {
  List<TempleData> get routingTempleDataList =>
      throw _privateConstructorUsedError;
  Map<String, TempleData> get routingTempleDataMap =>
      throw _privateConstructorUsedError;

  ///
  String get startStationId => throw _privateConstructorUsedError;
  String get goalStationId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoutingStateCopyWith<RoutingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutingStateCopyWith<$Res> {
  factory $RoutingStateCopyWith(
          RoutingState value, $Res Function(RoutingState) then) =
      _$RoutingStateCopyWithImpl<$Res, RoutingState>;
  @useResult
  $Res call(
      {List<TempleData> routingTempleDataList,
      Map<String, TempleData> routingTempleDataMap,
      String startStationId,
      String goalStationId});
}

/// @nodoc
class _$RoutingStateCopyWithImpl<$Res, $Val extends RoutingState>
    implements $RoutingStateCopyWith<$Res> {
  _$RoutingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routingTempleDataList = null,
    Object? routingTempleDataMap = null,
    Object? startStationId = null,
    Object? goalStationId = null,
  }) {
    return _then(_value.copyWith(
      routingTempleDataList: null == routingTempleDataList
          ? _value.routingTempleDataList
          : routingTempleDataList // ignore: cast_nullable_to_non_nullable
              as List<TempleData>,
      routingTempleDataMap: null == routingTempleDataMap
          ? _value.routingTempleDataMap
          : routingTempleDataMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleData>,
      startStationId: null == startStationId
          ? _value.startStationId
          : startStationId // ignore: cast_nullable_to_non_nullable
              as String,
      goalStationId: null == goalStationId
          ? _value.goalStationId
          : goalStationId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutingStateImplCopyWith<$Res>
    implements $RoutingStateCopyWith<$Res> {
  factory _$$RoutingStateImplCopyWith(
          _$RoutingStateImpl value, $Res Function(_$RoutingStateImpl) then) =
      __$$RoutingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TempleData> routingTempleDataList,
      Map<String, TempleData> routingTempleDataMap,
      String startStationId,
      String goalStationId});
}

/// @nodoc
class __$$RoutingStateImplCopyWithImpl<$Res>
    extends _$RoutingStateCopyWithImpl<$Res, _$RoutingStateImpl>
    implements _$$RoutingStateImplCopyWith<$Res> {
  __$$RoutingStateImplCopyWithImpl(
      _$RoutingStateImpl _value, $Res Function(_$RoutingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routingTempleDataList = null,
    Object? routingTempleDataMap = null,
    Object? startStationId = null,
    Object? goalStationId = null,
  }) {
    return _then(_$RoutingStateImpl(
      routingTempleDataList: null == routingTempleDataList
          ? _value._routingTempleDataList
          : routingTempleDataList // ignore: cast_nullable_to_non_nullable
              as List<TempleData>,
      routingTempleDataMap: null == routingTempleDataMap
          ? _value._routingTempleDataMap
          : routingTempleDataMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleData>,
      startStationId: null == startStationId
          ? _value.startStationId
          : startStationId // ignore: cast_nullable_to_non_nullable
              as String,
      goalStationId: null == goalStationId
          ? _value.goalStationId
          : goalStationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RoutingStateImpl implements _RoutingState {
  const _$RoutingStateImpl(
      {final List<TempleData> routingTempleDataList = const [],
      final Map<String, TempleData> routingTempleDataMap = const {},
      this.startStationId = '',
      this.goalStationId = ''})
      : _routingTempleDataList = routingTempleDataList,
        _routingTempleDataMap = routingTempleDataMap;

  final List<TempleData> _routingTempleDataList;
  @override
  @JsonKey()
  List<TempleData> get routingTempleDataList {
    if (_routingTempleDataList is EqualUnmodifiableListView)
      return _routingTempleDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routingTempleDataList);
  }

  final Map<String, TempleData> _routingTempleDataMap;
  @override
  @JsonKey()
  Map<String, TempleData> get routingTempleDataMap {
    if (_routingTempleDataMap is EqualUnmodifiableMapView)
      return _routingTempleDataMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_routingTempleDataMap);
  }

  ///
  @override
  @JsonKey()
  final String startStationId;
  @override
  @JsonKey()
  final String goalStationId;

  @override
  String toString() {
    return 'RoutingState(routingTempleDataList: $routingTempleDataList, routingTempleDataMap: $routingTempleDataMap, startStationId: $startStationId, goalStationId: $goalStationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._routingTempleDataList, _routingTempleDataList) &&
            const DeepCollectionEquality()
                .equals(other._routingTempleDataMap, _routingTempleDataMap) &&
            (identical(other.startStationId, startStationId) ||
                other.startStationId == startStationId) &&
            (identical(other.goalStationId, goalStationId) ||
                other.goalStationId == goalStationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_routingTempleDataList),
      const DeepCollectionEquality().hash(_routingTempleDataMap),
      startStationId,
      goalStationId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutingStateImplCopyWith<_$RoutingStateImpl> get copyWith =>
      __$$RoutingStateImplCopyWithImpl<_$RoutingStateImpl>(this, _$identity);
}

abstract class _RoutingState implements RoutingState {
  const factory _RoutingState(
      {final List<TempleData> routingTempleDataList,
      final Map<String, TempleData> routingTempleDataMap,
      final String startStationId,
      final String goalStationId}) = _$RoutingStateImpl;

  @override
  List<TempleData> get routingTempleDataList;
  @override
  Map<String, TempleData> get routingTempleDataMap;
  @override

  ///
  String get startStationId;
  @override
  String get goalStationId;
  @override
  @JsonKey(ignore: true)
  _$$RoutingStateImplCopyWith<_$RoutingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
