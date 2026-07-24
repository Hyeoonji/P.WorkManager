// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRef {

 String get id; String get name; String? get dept; String? get position; String? get photoUrl;
/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRefCopyWith<UserRef> get copyWith => _$UserRefCopyWithImpl<UserRef>(this as UserRef, _$identity);

  /// Serializes this UserRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dept, dept) || other.dept == dept)&&(identical(other.position, position) || other.position == position)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dept,position,photoUrl);

@override
String toString() {
  return 'UserRef(id: $id, name: $name, dept: $dept, position: $position, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $UserRefCopyWith<$Res>  {
  factory $UserRefCopyWith(UserRef value, $Res Function(UserRef) _then) = _$UserRefCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? dept, String? position, String? photoUrl
});




}
/// @nodoc
class _$UserRefCopyWithImpl<$Res>
    implements $UserRefCopyWith<$Res> {
  _$UserRefCopyWithImpl(this._self, this._then);

  final UserRef _self;
  final $Res Function(UserRef) _then;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dept = freezed,Object? position = freezed,Object? photoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dept: freezed == dept ? _self.dept : dept // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRef].
extension UserRefPatterns on UserRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRef value)  $default,){
final _that = this;
switch (_that) {
case _UserRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRef value)?  $default,){
final _that = this;
switch (_that) {
case _UserRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? dept,  String? position,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRef() when $default != null:
return $default(_that.id,_that.name,_that.dept,_that.position,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? dept,  String? position,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _UserRef():
return $default(_that.id,_that.name,_that.dept,_that.position,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? dept,  String? position,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _UserRef() when $default != null:
return $default(_that.id,_that.name,_that.dept,_that.position,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRef implements UserRef {
  const _UserRef({required this.id, required this.name, this.dept, this.position, this.photoUrl});
  factory _UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? dept;
@override final  String? position;
@override final  String? photoUrl;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRefCopyWith<_UserRef> get copyWith => __$UserRefCopyWithImpl<_UserRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dept, dept) || other.dept == dept)&&(identical(other.position, position) || other.position == position)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dept,position,photoUrl);

@override
String toString() {
  return 'UserRef(id: $id, name: $name, dept: $dept, position: $position, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$UserRefCopyWith<$Res> implements $UserRefCopyWith<$Res> {
  factory _$UserRefCopyWith(_UserRef value, $Res Function(_UserRef) _then) = __$UserRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? dept, String? position, String? photoUrl
});




}
/// @nodoc
class __$UserRefCopyWithImpl<$Res>
    implements _$UserRefCopyWith<$Res> {
  __$UserRefCopyWithImpl(this._self, this._then);

  final _UserRef _self;
  final $Res Function(_UserRef) _then;

/// Create a copy of UserRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dept = freezed,Object? position = freezed,Object? photoUrl = freezed,}) {
  return _then(_UserRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dept: freezed == dept ? _self.dept : dept // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
