// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Assignee {

 String get userId; String get name; bool get confirmed;
/// Create a copy of Assignee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssigneeCopyWith<Assignee> get copyWith => _$AssigneeCopyWithImpl<Assignee>(this as Assignee, _$identity);

  /// Serializes this Assignee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Assignee&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,confirmed);

@override
String toString() {
  return 'Assignee(userId: $userId, name: $name, confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class $AssigneeCopyWith<$Res>  {
  factory $AssigneeCopyWith(Assignee value, $Res Function(Assignee) _then) = _$AssigneeCopyWithImpl;
@useResult
$Res call({
 String userId, String name, bool confirmed
});




}
/// @nodoc
class _$AssigneeCopyWithImpl<$Res>
    implements $AssigneeCopyWith<$Res> {
  _$AssigneeCopyWithImpl(this._self, this._then);

  final Assignee _self;
  final $Res Function(Assignee) _then;

/// Create a copy of Assignee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? confirmed = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Assignee].
extension AssigneePatterns on Assignee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Assignee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Assignee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Assignee value)  $default,){
final _that = this;
switch (_that) {
case _Assignee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Assignee value)?  $default,){
final _that = this;
switch (_that) {
case _Assignee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String name,  bool confirmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Assignee() when $default != null:
return $default(_that.userId,_that.name,_that.confirmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String name,  bool confirmed)  $default,) {final _that = this;
switch (_that) {
case _Assignee():
return $default(_that.userId,_that.name,_that.confirmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String name,  bool confirmed)?  $default,) {final _that = this;
switch (_that) {
case _Assignee() when $default != null:
return $default(_that.userId,_that.name,_that.confirmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Assignee implements Assignee {
  const _Assignee({required this.userId, required this.name, this.confirmed = false});
  factory _Assignee.fromJson(Map<String, dynamic> json) => _$AssigneeFromJson(json);

@override final  String userId;
@override final  String name;
@override@JsonKey() final  bool confirmed;

/// Create a copy of Assignee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssigneeCopyWith<_Assignee> get copyWith => __$AssigneeCopyWithImpl<_Assignee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssigneeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Assignee&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,confirmed);

@override
String toString() {
  return 'Assignee(userId: $userId, name: $name, confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class _$AssigneeCopyWith<$Res> implements $AssigneeCopyWith<$Res> {
  factory _$AssigneeCopyWith(_Assignee value, $Res Function(_Assignee) _then) = __$AssigneeCopyWithImpl;
@override @useResult
$Res call({
 String userId, String name, bool confirmed
});




}
/// @nodoc
class __$AssigneeCopyWithImpl<$Res>
    implements _$AssigneeCopyWith<$Res> {
  __$AssigneeCopyWithImpl(this._self, this._then);

  final _Assignee _self;
  final $Res Function(_Assignee) _then;

/// Create a copy of Assignee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? confirmed = null,}) {
  return _then(_Assignee(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
