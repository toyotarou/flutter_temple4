// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TempleState {
  List<TempleModel> get templeList => throw _privateConstructorUsedError;
  Map<String, TempleModel> get templeMap => throw _privateConstructorUsedError;

  ///
  String get searchWord => throw _privateConstructorUsedError;
  bool get doSearch => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TempleStateCopyWith<TempleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempleStateCopyWith<$Res> {
  factory $TempleStateCopyWith(
          TempleState value, $Res Function(TempleState) then) =
      _$TempleStateCopyWithImpl<$Res, TempleState>;
  @useResult
  $Res call(
      {List<TempleModel> templeList,
      Map<String, TempleModel> templeMap,
      String searchWord,
      bool doSearch});
}

/// @nodoc
class _$TempleStateCopyWithImpl<$Res, $Val extends TempleState>
    implements $TempleStateCopyWith<$Res> {
  _$TempleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeList = null,
    Object? templeMap = null,
    Object? searchWord = null,
    Object? doSearch = null,
  }) {
    return _then(_value.copyWith(
      templeList: null == templeList
          ? _value.templeList
          : templeList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      templeMap: null == templeMap
          ? _value.templeMap
          : templeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleModel>,
      searchWord: null == searchWord
          ? _value.searchWord
          : searchWord // ignore: cast_nullable_to_non_nullable
              as String,
      doSearch: null == doSearch
          ? _value.doSearch
          : doSearch // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TempleStateImplCopyWith<$Res>
    implements $TempleStateCopyWith<$Res> {
  factory _$$TempleStateImplCopyWith(
          _$TempleStateImpl value, $Res Function(_$TempleStateImpl) then) =
      __$$TempleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TempleModel> templeList,
      Map<String, TempleModel> templeMap,
      String searchWord,
      bool doSearch});
}

/// @nodoc
class __$$TempleStateImplCopyWithImpl<$Res>
    extends _$TempleStateCopyWithImpl<$Res, _$TempleStateImpl>
    implements _$$TempleStateImplCopyWith<$Res> {
  __$$TempleStateImplCopyWithImpl(
      _$TempleStateImpl _value, $Res Function(_$TempleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeList = null,
    Object? templeMap = null,
    Object? searchWord = null,
    Object? doSearch = null,
  }) {
    return _then(_$TempleStateImpl(
      templeList: null == templeList
          ? _value._templeList
          : templeList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      templeMap: null == templeMap
          ? _value._templeMap
          : templeMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleModel>,
      searchWord: null == searchWord
          ? _value.searchWord
          : searchWord // ignore: cast_nullable_to_non_nullable
              as String,
      doSearch: null == doSearch
          ? _value.doSearch
          : doSearch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TempleStateImpl implements _TempleState {
  const _$TempleStateImpl(
      {final List<TempleModel> templeList = const [],
      final Map<String, TempleModel> templeMap = const {},
      this.searchWord = '',
      this.doSearch = false})
      : _templeList = templeList,
        _templeMap = templeMap;

  final List<TempleModel> _templeList;
  @override
  @JsonKey()
  List<TempleModel> get templeList {
    if (_templeList is EqualUnmodifiableListView) return _templeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templeList);
  }

  final Map<String, TempleModel> _templeMap;
  @override
  @JsonKey()
  Map<String, TempleModel> get templeMap {
    if (_templeMap is EqualUnmodifiableMapView) return _templeMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_templeMap);
  }

  ///
  @override
  @JsonKey()
  final String searchWord;
  @override
  @JsonKey()
  final bool doSearch;

  @override
  String toString() {
    return 'TempleState(templeList: $templeList, templeMap: $templeMap, searchWord: $searchWord, doSearch: $doSearch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TempleStateImpl &&
            const DeepCollectionEquality()
                .equals(other._templeList, _templeList) &&
            const DeepCollectionEquality()
                .equals(other._templeMap, _templeMap) &&
            (identical(other.searchWord, searchWord) ||
                other.searchWord == searchWord) &&
            (identical(other.doSearch, doSearch) ||
                other.doSearch == doSearch));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_templeList),
      const DeepCollectionEquality().hash(_templeMap),
      searchWord,
      doSearch);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TempleStateImplCopyWith<_$TempleStateImpl> get copyWith =>
      __$$TempleStateImplCopyWithImpl<_$TempleStateImpl>(this, _$identity);
}

abstract class _TempleState implements TempleState {
  const factory _TempleState(
      {final List<TempleModel> templeList,
      final Map<String, TempleModel> templeMap,
      final String searchWord,
      final bool doSearch}) = _$TempleStateImpl;

  @override
  List<TempleModel> get templeList;
  @override
  Map<String, TempleModel> get templeMap;
  @override

  ///
  String get searchWord;
  @override
  bool get doSearch;
  @override
  @JsonKey(ignore: true)
  _$$TempleStateImplCopyWith<_$TempleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
