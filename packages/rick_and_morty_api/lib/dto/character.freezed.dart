// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

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


/// @nodoc
mixin _$Character {

 int get id; String get name; Uri get url; DateTime get created;@JsonKey(unknownEnumValue: CharacterStatus.unknown) CharacterStatus get status; String get species; String get type;@JsonKey(unknownEnumValue: CharacterGender.unknown) CharacterGender get gender; CharacterLocation get origin; CharacterLocation get location; String get image; List<String> get episode;
/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterCopyWith<Character> get copyWith => _$CharacterCopyWithImpl<Character>(this as Character, _$identity);

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Character;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Character&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.created, _this.created) || other.created == _this.created)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.species, _this.species) || other.species == _this.species)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.image, _this.image) || other.image == _this.image)&&const DeepCollectionEquality().equals(other.episode, _this.episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Character;
  return Object.hash(runtimeType,_this.id,_this.name,_this.url,_this.created,_this.status,_this.species,_this.type,_this.gender,_this.origin,_this.location,_this.image,const DeepCollectionEquality().hash(_this.episode));
}

@override
String toString() {
  final _this = this as Character;
  return 'Character(id: ${_this.id}, name: ${_this.name}, url: ${_this.url}, created: ${_this.created}, status: ${_this.status}, species: ${_this.species}, type: ${_this.type}, gender: ${_this.gender}, origin: ${_this.origin}, location: ${_this.location}, image: ${_this.image}, episode: ${_this.episode})';
}


}

/// @nodoc
abstract mixin class $CharacterCopyWith<$Res>  {
  factory $CharacterCopyWith(Character value, $Res Function(Character) _then) = _$CharacterCopyWithImpl;
@useResult
$Res call({
 int id, String name, Uri url, DateTime created,@JsonKey(unknownEnumValue: CharacterStatus.unknown) CharacterStatus status, String species, String type,@JsonKey(unknownEnumValue: CharacterGender.unknown) CharacterGender gender, CharacterLocation origin, CharacterLocation location, String image, List<String> episode
});


$CharacterLocationCopyWith<$Res> get origin;$CharacterLocationCopyWith<$Res> get location;

}
/// @nodoc
class _$CharacterCopyWithImpl<$Res>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._self, this._then);

  final Character _self;
  final $Res Function(Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? url = null,Object? created = null,Object? status = null,Object? species = null,Object? type = null,Object? gender = null,Object? origin = null,Object? location = null,Object? image = null,Object? episode = null,}) {
  return _then(Character(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CharacterStatus,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as CharacterGender,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as CharacterLocation,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CharacterLocation,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterLocationCopyWith<$Res> get origin {
  
  return $CharacterLocationCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterLocationCopyWith<$Res> get location {
  
  return $CharacterLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Character].
extension CharacterPatterns on Character {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Character value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Character value)  $default,){
final _that = this;
switch (_that) {
case _Character():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Character value)?  $default,){
final _that = this;
switch (_that) {
case _Character() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  Uri url,  DateTime created, @JsonKey(unknownEnumValue: CharacterStatus.unknown)  CharacterStatus status,  String species,  String type, @JsonKey(unknownEnumValue: CharacterGender.unknown)  CharacterGender gender,  CharacterLocation origin,  CharacterLocation location,  String image,  List<String> episode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.created,_that.status,_that.species,_that.type,_that.gender,_that.origin,_that.location,_that.image,_that.episode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  Uri url,  DateTime created, @JsonKey(unknownEnumValue: CharacterStatus.unknown)  CharacterStatus status,  String species,  String type, @JsonKey(unknownEnumValue: CharacterGender.unknown)  CharacterGender gender,  CharacterLocation origin,  CharacterLocation location,  String image,  List<String> episode)  $default,) {final _that = this;
switch (_that) {
case _Character():
return $default(_that.id,_that.name,_that.url,_that.created,_that.status,_that.species,_that.type,_that.gender,_that.origin,_that.location,_that.image,_that.episode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  Uri url,  DateTime created, @JsonKey(unknownEnumValue: CharacterStatus.unknown)  CharacterStatus status,  String species,  String type, @JsonKey(unknownEnumValue: CharacterGender.unknown)  CharacterGender gender,  CharacterLocation origin,  CharacterLocation location,  String image,  List<String> episode)?  $default,) {final _that = this;
switch (_that) {
case _Character() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.created,_that.status,_that.species,_that.type,_that.gender,_that.origin,_that.location,_that.image,_that.episode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Character implements Character {
  const _Character({required this.id, required this.name, required this.url, required this.created, @JsonKey(unknownEnumValue: CharacterStatus.unknown) required this.status, required this.species, this.type = '', @JsonKey(unknownEnumValue: CharacterGender.unknown) required this.gender, required this.origin, required this.location, required this.image, required  List<String> episode}): _episode = episode;
  factory _Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

@override final  int id;
@override final  String name;
@override final  Uri url;
@override final  DateTime created;
@override@JsonKey(unknownEnumValue: CharacterStatus.unknown) final  CharacterStatus status;
@override final  String species;
@override@JsonKey() final  String type;
@override@JsonKey(unknownEnumValue: CharacterGender.unknown) final  CharacterGender gender;
@override final  CharacterLocation origin;
@override final  CharacterLocation location;
@override final  String image;
 final  List<String> _episode;
@override List<String> get episode {
  if (_episode is EqualUnmodifiableListView) return _episode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episode);
}


/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterCopyWith<_Character> get copyWith => __$CharacterCopyWithImpl<_Character>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Character&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.created, created) || other.created == created)&&(identical(other.status, status) || other.status == status)&&(identical(other.species, species) || other.species == species)&&(identical(other.type, type) || other.type == type)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.location, location) || other.location == location)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.episode, _episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,url,created,status,species,type,gender,origin,location,image,const DeepCollectionEquality().hash(_episode));
}

@override
String toString() {
    return 'Character(id: $id, name: $name, url: $url, created: $created, status: $status, species: $species, type: $type, gender: $gender, origin: $origin, location: $location, image: $image, episode: $episode)';
}


}

/// @nodoc
abstract mixin class _$CharacterCopyWith<$Res> implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(_Character value, $Res Function(_Character) _then) = __$CharacterCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, Uri url, DateTime created,@JsonKey(unknownEnumValue: CharacterStatus.unknown) CharacterStatus status, String species, String type,@JsonKey(unknownEnumValue: CharacterGender.unknown) CharacterGender gender, CharacterLocation origin, CharacterLocation location, String image, List<String> episode
});


@override $CharacterLocationCopyWith<$Res> get origin;@override $CharacterLocationCopyWith<$Res> get location;

}
/// @nodoc
class __$CharacterCopyWithImpl<$Res>
    implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(this._self, this._then);

  final _Character _self;
  final $Res Function(_Character) _then;

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? url = null,Object? created = null,Object? status = null,Object? species = null,Object? type = null,Object? gender = null,Object? origin = null,Object? location = null,Object? image = null,Object? episode = null,}) {
  return _then(_Character(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CharacterStatus,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as CharacterGender,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as CharacterLocation,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CharacterLocation,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,episode: null == episode ? _self._episode : episode // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterLocationCopyWith<$Res> get origin {
  
  return $CharacterLocationCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Character
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterLocationCopyWith<$Res> get location {
  
  return $CharacterLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
