// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paged_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PagedResponse<T> {

@JsonKey(name: 'info') Info? get info;@JsonKey(name: 'results') List<T> get results;
/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagedResponseCopyWith<T, PagedResponse<T>> get copyWith => _$PagedResponseCopyWithImpl<T, PagedResponse<T>>(this as PagedResponse<T>, _$identity);

  /// Serializes this PagedResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  final _this = this as PagedResponse<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagedResponse<T>&&(identical(other.info, _this.info) || other.info == _this.info)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PagedResponse<T>;
  return Object.hash(runtimeType,_this.info,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as PagedResponse<T>;
  return 'PagedResponse<$T>(info: ${_this.info}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $PagedResponseCopyWith<T,$Res>  {
  factory $PagedResponseCopyWith(PagedResponse<T> value, $Res Function(PagedResponse<T>) _then) = _$PagedResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'info') Info? info,@JsonKey(name: 'results') List<T> results
});


$InfoCopyWith<$Res>? get info;

}
/// @nodoc
class _$PagedResponseCopyWithImpl<T,$Res>
    implements $PagedResponseCopyWith<T, $Res> {
  _$PagedResponseCopyWithImpl(this._self, this._then);

  final PagedResponse<T> _self;
  final $Res Function(PagedResponse<T>) _then;

/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = freezed,Object? results = null,}) {
  return _then(PagedResponse(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}
/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [PagedResponse].
extension PagedResponsePatterns<T> on PagedResponse<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PagedResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PagedResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PagedResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _PagedResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PagedResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PagedResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'info')  Info? info, @JsonKey(name: 'results')  List<T> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PagedResponse() when $default != null:
return $default(_that.info,_that.results);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'info')  Info? info, @JsonKey(name: 'results')  List<T> results)  $default,) {final _that = this;
switch (_that) {
case _PagedResponse():
return $default(_that.info,_that.results);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'info')  Info? info, @JsonKey(name: 'results')  List<T> results)?  $default,) {final _that = this;
switch (_that) {
case _PagedResponse() when $default != null:
return $default(_that.info,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PagedResponse<T> implements PagedResponse<T> {
  const _PagedResponse({@JsonKey(name: 'info') required this.info, @JsonKey(name: 'results') required  List<T> results}): _results = results;
  factory _PagedResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PagedResponseFromJson(json,fromJsonT);

@override@JsonKey(name: 'info') final  Info? info;
 final  List<T> _results;
@override@JsonKey(name: 'results') List<T> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PagedResponseCopyWith<T, _PagedResponse<T>> get copyWith => __$PagedResponseCopyWithImpl<T, _PagedResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PagedResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PagedResponse<T>&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,info,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'PagedResponse<$T>(info: $info, results: $results)';
}


}

/// @nodoc
abstract mixin class _$PagedResponseCopyWith<T,$Res> implements $PagedResponseCopyWith<T, $Res> {
  factory _$PagedResponseCopyWith(_PagedResponse<T> value, $Res Function(_PagedResponse<T>) _then) = __$PagedResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'info') Info? info,@JsonKey(name: 'results') List<T> results
});


@override $InfoCopyWith<$Res>? get info;

}
/// @nodoc
class __$PagedResponseCopyWithImpl<T,$Res>
    implements _$PagedResponseCopyWith<T, $Res> {
  __$PagedResponseCopyWithImpl(this._self, this._then);

  final _PagedResponse<T> _self;
  final $Res Function(_PagedResponse<T>) _then;

/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = freezed,Object? results = null,}) {
  return _then(_PagedResponse<T>(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

/// Create a copy of PagedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// @nodoc
mixin _$Info {

@JsonKey(name: 'count') int get count;@JsonKey(name: 'pages') int get pages;@JsonKey(name: 'next') String? get next;@JsonKey(name: 'prev') String? get prev;
/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoCopyWith<Info> get copyWith => _$InfoCopyWithImpl<Info>(this as Info, _$identity);

  /// Serializes this Info to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Info;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Info&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.pages, _this.pages) || other.pages == _this.pages)&&(identical(other.next, _this.next) || other.next == _this.next)&&(identical(other.prev, _this.prev) || other.prev == _this.prev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Info;
  return Object.hash(runtimeType,_this.count,_this.pages,_this.next,_this.prev);
}

@override
String toString() {
  final _this = this as Info;
  return 'Info(count: ${_this.count}, pages: ${_this.pages}, next: ${_this.next}, prev: ${_this.prev})';
}


}

/// @nodoc
abstract mixin class $InfoCopyWith<$Res>  {
  factory $InfoCopyWith(Info value, $Res Function(Info) _then) = _$InfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'count') int count,@JsonKey(name: 'pages') int pages,@JsonKey(name: 'next') String? next,@JsonKey(name: 'prev') String? prev
});




}
/// @nodoc
class _$InfoCopyWithImpl<$Res>
    implements $InfoCopyWith<$Res> {
  _$InfoCopyWithImpl(this._self, this._then);

  final Info _self;
  final $Res Function(Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? pages = null,Object? next = freezed,Object? prev = freezed,}) {
  return _then(Info(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Info].
extension InfoPatterns on Info {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Info value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Info value)  $default,){
final _that = this;
switch (_that) {
case _Info():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Info value)?  $default,){
final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'count')  int count, @JsonKey(name: 'pages')  int pages, @JsonKey(name: 'next')  String? next, @JsonKey(name: 'prev')  String? prev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.count,_that.pages,_that.next,_that.prev);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'count')  int count, @JsonKey(name: 'pages')  int pages, @JsonKey(name: 'next')  String? next, @JsonKey(name: 'prev')  String? prev)  $default,) {final _that = this;
switch (_that) {
case _Info():
return $default(_that.count,_that.pages,_that.next,_that.prev);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'count')  int count, @JsonKey(name: 'pages')  int pages, @JsonKey(name: 'next')  String? next, @JsonKey(name: 'prev')  String? prev)?  $default,) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.count,_that.pages,_that.next,_that.prev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Info implements Info {
  const _Info({@JsonKey(name: 'count') required this.count, @JsonKey(name: 'pages') required this.pages, @JsonKey(name: 'next') required this.next, @JsonKey(name: 'prev') required this.prev});
  factory _Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

@override@JsonKey(name: 'count') final  int count;
@override@JsonKey(name: 'pages') final  int pages;
@override@JsonKey(name: 'next') final  String? next;
@override@JsonKey(name: 'prev') final  String? prev;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoCopyWith<_Info> get copyWith => __$InfoCopyWithImpl<_Info>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Info&&(identical(other.count, count) || other.count == count)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.next, next) || other.next == next)&&(identical(other.prev, prev) || other.prev == prev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count,pages,next,prev);
}

@override
String toString() {
    return 'Info(count: $count, pages: $pages, next: $next, prev: $prev)';
}


}

/// @nodoc
abstract mixin class _$InfoCopyWith<$Res> implements $InfoCopyWith<$Res> {
  factory _$InfoCopyWith(_Info value, $Res Function(_Info) _then) = __$InfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'count') int count,@JsonKey(name: 'pages') int pages,@JsonKey(name: 'next') String? next,@JsonKey(name: 'prev') String? prev
});




}
/// @nodoc
class __$InfoCopyWithImpl<$Res>
    implements _$InfoCopyWith<$Res> {
  __$InfoCopyWithImpl(this._self, this._then);

  final _Info _self;
  final $Res Function(_Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? pages = null,Object? next = freezed,Object? prev = freezed,}) {
  return _then(_Info(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
