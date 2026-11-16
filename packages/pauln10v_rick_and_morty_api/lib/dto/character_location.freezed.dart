// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CharacterLocation {

 String get name; Uri get url;
/// Create a copy of CharacterLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterLocationCopyWith<CharacterLocation> get copyWith => _$CharacterLocationCopyWithImpl<CharacterLocation>(this as CharacterLocation, _$identity);

  /// Serializes this CharacterLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CharacterLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterLocation&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.url, _this.url) || other.url == _this.url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CharacterLocation;
  return Object.hash(runtimeType,_this.name,_this.url);
}

@override
String toString() {
  final _this = this as CharacterLocation;
  return 'CharacterLocation(name: ${_this.name}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $CharacterLocationCopyWith<$Res>  {
  factory $CharacterLocationCopyWith(CharacterLocation value, $Res Function(CharacterLocation) _then) = _$CharacterLocationCopyWithImpl;
@useResult
$Res call({
 String name, Uri url
});




}
/// @nodoc
class _$CharacterLocationCopyWithImpl<$Res>
    implements $CharacterLocationCopyWith<$Res> {
  _$CharacterLocationCopyWithImpl(this._self, this._then);

  final CharacterLocation _self;
  final $Res Function(CharacterLocation) _then;

/// Create a copy of CharacterLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,}) {
  return _then(CharacterLocation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterLocation].
extension CharacterLocationPatterns on CharacterLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterLocation value)  $default,){
final _that = this;
switch (_that) {
case _CharacterLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterLocation value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Uri url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterLocation() when $default != null:
return $default(_that.name,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Uri url)  $default,) {final _that = this;
switch (_that) {
case _CharacterLocation():
return $default(_that.name,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Uri url)?  $default,) {final _that = this;
switch (_that) {
case _CharacterLocation() when $default != null:
return $default(_that.name,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterLocation implements CharacterLocation {
  const _CharacterLocation({required this.name, required this.url});
  factory _CharacterLocation.fromJson(Map<String, dynamic> json) => _$CharacterLocationFromJson(json);

@override final  String name;
@override final  Uri url;

/// Create a copy of CharacterLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterLocationCopyWith<_CharacterLocation> get copyWith => __$CharacterLocationCopyWithImpl<_CharacterLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterLocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterLocation&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,url);
}

@override
String toString() {
    return 'CharacterLocation(name: $name, url: $url)';
}


}

/// @nodoc
abstract mixin class _$CharacterLocationCopyWith<$Res> implements $CharacterLocationCopyWith<$Res> {
  factory _$CharacterLocationCopyWith(_CharacterLocation value, $Res Function(_CharacterLocation) _then) = __$CharacterLocationCopyWithImpl;
@override @useResult
$Res call({
 String name, Uri url
});




}
/// @nodoc
class __$CharacterLocationCopyWithImpl<$Res>
    implements _$CharacterLocationCopyWith<$Res> {
  __$CharacterLocationCopyWithImpl(this._self, this._then);

  final _CharacterLocation _self;
  final $Res Function(_CharacterLocation) _then;

/// Create a copy of CharacterLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,}) {
  return _then(_CharacterLocation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

// dart format on
