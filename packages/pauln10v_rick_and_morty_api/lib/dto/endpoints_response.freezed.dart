// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoints_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EndpointsResponse {

@JsonKey(name: 'characters') Uri get characters;@JsonKey(name: 'locations') Uri get locations;@JsonKey(name: 'episodes') Uri get episodes;
/// Create a copy of EndpointsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndpointsResponseCopyWith<EndpointsResponse> get copyWith => _$EndpointsResponseCopyWithImpl<EndpointsResponse>(this as EndpointsResponse, _$identity);

  /// Serializes this EndpointsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EndpointsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndpointsResponse&&(identical(other.characters, _this.characters) || other.characters == _this.characters)&&(identical(other.locations, _this.locations) || other.locations == _this.locations)&&(identical(other.episodes, _this.episodes) || other.episodes == _this.episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EndpointsResponse;
  return Object.hash(runtimeType,_this.characters,_this.locations,_this.episodes);
}

@override
String toString() {
  final _this = this as EndpointsResponse;
  return 'EndpointsResponse(characters: ${_this.characters}, locations: ${_this.locations}, episodes: ${_this.episodes})';
}


}

/// @nodoc
abstract mixin class $EndpointsResponseCopyWith<$Res>  {
  factory $EndpointsResponseCopyWith(EndpointsResponse value, $Res Function(EndpointsResponse) _then) = _$EndpointsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'characters') Uri characters,@JsonKey(name: 'locations') Uri locations,@JsonKey(name: 'episodes') Uri episodes
});




}
/// @nodoc
class _$EndpointsResponseCopyWithImpl<$Res>
    implements $EndpointsResponseCopyWith<$Res> {
  _$EndpointsResponseCopyWithImpl(this._self, this._then);

  final EndpointsResponse _self;
  final $Res Function(EndpointsResponse) _then;

/// Create a copy of EndpointsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? characters = null,Object? locations = null,Object? episodes = null,}) {
  return _then(EndpointsResponse(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as Uri,locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as Uri,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

}


/// Adds pattern-matching-related methods to [EndpointsResponse].
extension EndpointsResponsePatterns on EndpointsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndpointsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndpointsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndpointsResponse value)  $default,){
final _that = this;
switch (_that) {
case _EndpointsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndpointsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EndpointsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'characters')  Uri characters, @JsonKey(name: 'locations')  Uri locations, @JsonKey(name: 'episodes')  Uri episodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndpointsResponse() when $default != null:
return $default(_that.characters,_that.locations,_that.episodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'characters')  Uri characters, @JsonKey(name: 'locations')  Uri locations, @JsonKey(name: 'episodes')  Uri episodes)  $default,) {final _that = this;
switch (_that) {
case _EndpointsResponse():
return $default(_that.characters,_that.locations,_that.episodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'characters')  Uri characters, @JsonKey(name: 'locations')  Uri locations, @JsonKey(name: 'episodes')  Uri episodes)?  $default,) {final _that = this;
switch (_that) {
case _EndpointsResponse() when $default != null:
return $default(_that.characters,_that.locations,_that.episodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndpointsResponse implements EndpointsResponse {
  const _EndpointsResponse({@JsonKey(name: 'characters') required this.characters, @JsonKey(name: 'locations') required this.locations, @JsonKey(name: 'episodes') required this.episodes});
  factory _EndpointsResponse.fromJson(Map<String, dynamic> json) => _$EndpointsResponseFromJson(json);

@override@JsonKey(name: 'characters') final  Uri characters;
@override@JsonKey(name: 'locations') final  Uri locations;
@override@JsonKey(name: 'episodes') final  Uri episodes;

/// Create a copy of EndpointsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndpointsResponseCopyWith<_EndpointsResponse> get copyWith => __$EndpointsResponseCopyWithImpl<_EndpointsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndpointsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndpointsResponse&&(identical(other.characters, characters) || other.characters == characters)&&(identical(other.locations, locations) || other.locations == locations)&&(identical(other.episodes, episodes) || other.episodes == episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,characters,locations,episodes);
}

@override
String toString() {
    return 'EndpointsResponse(characters: $characters, locations: $locations, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class _$EndpointsResponseCopyWith<$Res> implements $EndpointsResponseCopyWith<$Res> {
  factory _$EndpointsResponseCopyWith(_EndpointsResponse value, $Res Function(_EndpointsResponse) _then) = __$EndpointsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'characters') Uri characters,@JsonKey(name: 'locations') Uri locations,@JsonKey(name: 'episodes') Uri episodes
});




}
/// @nodoc
class __$EndpointsResponseCopyWithImpl<$Res>
    implements _$EndpointsResponseCopyWith<$Res> {
  __$EndpointsResponseCopyWithImpl(this._self, this._then);

  final _EndpointsResponse _self;
  final $Res Function(_EndpointsResponse) _then;

/// Create a copy of EndpointsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? characters = null,Object? locations = null,Object? episodes = null,}) {
  return _then(_EndpointsResponse(
characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as Uri,locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as Uri,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

// dart format on
