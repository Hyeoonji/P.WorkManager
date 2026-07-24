// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoProject {

 String get id; String get name; String? get clientName;
/// Create a copy of MemoProject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoProjectCopyWith<MemoProject> get copyWith => _$MemoProjectCopyWithImpl<MemoProject>(this as MemoProject, _$identity);

  /// Serializes this MemoProject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoProject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.clientName, clientName) || other.clientName == clientName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,clientName);

@override
String toString() {
  return 'MemoProject(id: $id, name: $name, clientName: $clientName)';
}


}

/// @nodoc
abstract mixin class $MemoProjectCopyWith<$Res>  {
  factory $MemoProjectCopyWith(MemoProject value, $Res Function(MemoProject) _then) = _$MemoProjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? clientName
});




}
/// @nodoc
class _$MemoProjectCopyWithImpl<$Res>
    implements $MemoProjectCopyWith<$Res> {
  _$MemoProjectCopyWithImpl(this._self, this._then);

  final MemoProject _self;
  final $Res Function(MemoProject) _then;

/// Create a copy of MemoProject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? clientName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoProject].
extension MemoProjectPatterns on MemoProject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoProject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoProject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoProject value)  $default,){
final _that = this;
switch (_that) {
case _MemoProject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoProject value)?  $default,){
final _that = this;
switch (_that) {
case _MemoProject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? clientName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoProject() when $default != null:
return $default(_that.id,_that.name,_that.clientName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? clientName)  $default,) {final _that = this;
switch (_that) {
case _MemoProject():
return $default(_that.id,_that.name,_that.clientName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? clientName)?  $default,) {final _that = this;
switch (_that) {
case _MemoProject() when $default != null:
return $default(_that.id,_that.name,_that.clientName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoProject implements MemoProject {
  const _MemoProject({required this.id, required this.name, this.clientName});
  factory _MemoProject.fromJson(Map<String, dynamic> json) => _$MemoProjectFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? clientName;

/// Create a copy of MemoProject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoProjectCopyWith<_MemoProject> get copyWith => __$MemoProjectCopyWithImpl<_MemoProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoProject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.clientName, clientName) || other.clientName == clientName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,clientName);

@override
String toString() {
  return 'MemoProject(id: $id, name: $name, clientName: $clientName)';
}


}

/// @nodoc
abstract mixin class _$MemoProjectCopyWith<$Res> implements $MemoProjectCopyWith<$Res> {
  factory _$MemoProjectCopyWith(_MemoProject value, $Res Function(_MemoProject) _then) = __$MemoProjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? clientName
});




}
/// @nodoc
class __$MemoProjectCopyWithImpl<$Res>
    implements _$MemoProjectCopyWith<$Res> {
  __$MemoProjectCopyWithImpl(this._self, this._then);

  final _MemoProject _self;
  final $Res Function(_MemoProject) _then;

/// Create a copy of MemoProject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? clientName = freezed,}) {
  return _then(_MemoProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
