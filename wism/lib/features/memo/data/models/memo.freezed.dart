// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Memo {

 String get id; String get title; String? get content; String get priority;// 긴급 | 일반
 String get category;// 일정 | 이슈 | 결정사항 | 회의록 | 기타
 MemoProject? get project; DateTime? get scheduledDate; UserRef get author; List<Assignee> get assignees; DateTime get createdAt; int get readBy; int get totalReaders; int get viewCount; int get commentCount; bool get bookmarked; bool get isRead; bool get isConfirmer;// 현재 사용자가 이 메모의 확인자인지
 bool get confirmedByMe;// 현재 사용자가 확인(읽음) 완료했는지
 List<Comment> get comments; List<Attachment> get attachments;
/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoCopyWith<Memo> get copyWith => _$MemoCopyWithImpl<Memo>(this as Memo, _$identity);

  /// Serializes this Memo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Memo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&(identical(other.project, project) || other.project == project)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readBy, readBy) || other.readBy == readBy)&&(identical(other.totalReaders, totalReaders) || other.totalReaders == totalReaders)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isConfirmer, isConfirmer) || other.isConfirmer == isConfirmer)&&(identical(other.confirmedByMe, confirmedByMe) || other.confirmedByMe == confirmedByMe)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,content,priority,category,project,scheduledDate,author,const DeepCollectionEquality().hash(assignees),createdAt,readBy,totalReaders,viewCount,commentCount,bookmarked,isRead,isConfirmer,confirmedByMe,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(attachments)]);

@override
String toString() {
  return 'Memo(id: $id, title: $title, content: $content, priority: $priority, category: $category, project: $project, scheduledDate: $scheduledDate, author: $author, assignees: $assignees, createdAt: $createdAt, readBy: $readBy, totalReaders: $totalReaders, viewCount: $viewCount, commentCount: $commentCount, bookmarked: $bookmarked, isRead: $isRead, isConfirmer: $isConfirmer, confirmedByMe: $confirmedByMe, comments: $comments, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $MemoCopyWith<$Res>  {
  factory $MemoCopyWith(Memo value, $Res Function(Memo) _then) = _$MemoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? content, String priority, String category, MemoProject? project, DateTime? scheduledDate, UserRef author, List<Assignee> assignees, DateTime createdAt, int readBy, int totalReaders, int viewCount, int commentCount, bool bookmarked, bool isRead, bool isConfirmer, bool confirmedByMe, List<Comment> comments, List<Attachment> attachments
});


$MemoProjectCopyWith<$Res>? get project;$UserRefCopyWith<$Res> get author;

}
/// @nodoc
class _$MemoCopyWithImpl<$Res>
    implements $MemoCopyWith<$Res> {
  _$MemoCopyWithImpl(this._self, this._then);

  final Memo _self;
  final $Res Function(Memo) _then;

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? priority = null,Object? category = null,Object? project = freezed,Object? scheduledDate = freezed,Object? author = null,Object? assignees = null,Object? createdAt = null,Object? readBy = null,Object? totalReaders = null,Object? viewCount = null,Object? commentCount = null,Object? bookmarked = null,Object? isRead = null,Object? isConfirmer = null,Object? confirmedByMe = null,Object? comments = null,Object? attachments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as MemoProject?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<Assignee>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,readBy: null == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as int,totalReaders: null == totalReaders ? _self.totalReaders : totalReaders // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isConfirmer: null == isConfirmer ? _self.isConfirmer : isConfirmer // ignore: cast_nullable_to_non_nullable
as bool,confirmedByMe: null == confirmedByMe ? _self.confirmedByMe : confirmedByMe // ignore: cast_nullable_to_non_nullable
as bool,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}
/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoProjectCopyWith<$Res>? get project {
    if (_self.project == null) {
    return null;
  }

  return $MemoProjectCopyWith<$Res>(_self.project!, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res> get author {
  
  return $UserRefCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Memo].
extension MemoPatterns on Memo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Memo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Memo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Memo value)  $default,){
final _that = this;
switch (_that) {
case _Memo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Memo value)?  $default,){
final _that = this;
switch (_that) {
case _Memo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? content,  String priority,  String category,  MemoProject? project,  DateTime? scheduledDate,  UserRef author,  List<Assignee> assignees,  DateTime createdAt,  int readBy,  int totalReaders,  int viewCount,  int commentCount,  bool bookmarked,  bool isRead,  bool isConfirmer,  bool confirmedByMe,  List<Comment> comments,  List<Attachment> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.priority,_that.category,_that.project,_that.scheduledDate,_that.author,_that.assignees,_that.createdAt,_that.readBy,_that.totalReaders,_that.viewCount,_that.commentCount,_that.bookmarked,_that.isRead,_that.isConfirmer,_that.confirmedByMe,_that.comments,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? content,  String priority,  String category,  MemoProject? project,  DateTime? scheduledDate,  UserRef author,  List<Assignee> assignees,  DateTime createdAt,  int readBy,  int totalReaders,  int viewCount,  int commentCount,  bool bookmarked,  bool isRead,  bool isConfirmer,  bool confirmedByMe,  List<Comment> comments,  List<Attachment> attachments)  $default,) {final _that = this;
switch (_that) {
case _Memo():
return $default(_that.id,_that.title,_that.content,_that.priority,_that.category,_that.project,_that.scheduledDate,_that.author,_that.assignees,_that.createdAt,_that.readBy,_that.totalReaders,_that.viewCount,_that.commentCount,_that.bookmarked,_that.isRead,_that.isConfirmer,_that.confirmedByMe,_that.comments,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? content,  String priority,  String category,  MemoProject? project,  DateTime? scheduledDate,  UserRef author,  List<Assignee> assignees,  DateTime createdAt,  int readBy,  int totalReaders,  int viewCount,  int commentCount,  bool bookmarked,  bool isRead,  bool isConfirmer,  bool confirmedByMe,  List<Comment> comments,  List<Attachment> attachments)?  $default,) {final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.priority,_that.category,_that.project,_that.scheduledDate,_that.author,_that.assignees,_that.createdAt,_that.readBy,_that.totalReaders,_that.viewCount,_that.commentCount,_that.bookmarked,_that.isRead,_that.isConfirmer,_that.confirmedByMe,_that.comments,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Memo implements Memo {
  const _Memo({required this.id, required this.title, this.content, this.priority = '일반', this.category = '기타', this.project, this.scheduledDate, required this.author, final  List<Assignee> assignees = const <Assignee>[], required this.createdAt, this.readBy = 0, this.totalReaders = 0, this.viewCount = 0, this.commentCount = 0, this.bookmarked = false, this.isRead = false, this.isConfirmer = false, this.confirmedByMe = false, final  List<Comment> comments = const <Comment>[], final  List<Attachment> attachments = const <Attachment>[]}): _assignees = assignees,_comments = comments,_attachments = attachments;
  factory _Memo.fromJson(Map<String, dynamic> json) => _$MemoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? content;
@override@JsonKey() final  String priority;
// 긴급 | 일반
@override@JsonKey() final  String category;
// 일정 | 이슈 | 결정사항 | 회의록 | 기타
@override final  MemoProject? project;
@override final  DateTime? scheduledDate;
@override final  UserRef author;
 final  List<Assignee> _assignees;
@override@JsonKey() List<Assignee> get assignees {
  if (_assignees is EqualUnmodifiableListView) return _assignees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignees);
}

@override final  DateTime createdAt;
@override@JsonKey() final  int readBy;
@override@JsonKey() final  int totalReaders;
@override@JsonKey() final  int viewCount;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  bool bookmarked;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isConfirmer;
// 현재 사용자가 이 메모의 확인자인지
@override@JsonKey() final  bool confirmedByMe;
// 현재 사용자가 확인(읽음) 완료했는지
 final  List<Comment> _comments;
// 현재 사용자가 확인(읽음) 완료했는지
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoCopyWith<_Memo> get copyWith => __$MemoCopyWithImpl<_Memo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Memo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.category, category) || other.category == category)&&(identical(other.project, project) || other.project == project)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._assignees, _assignees)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readBy, readBy) || other.readBy == readBy)&&(identical(other.totalReaders, totalReaders) || other.totalReaders == totalReaders)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isConfirmer, isConfirmer) || other.isConfirmer == isConfirmer)&&(identical(other.confirmedByMe, confirmedByMe) || other.confirmedByMe == confirmedByMe)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,content,priority,category,project,scheduledDate,author,const DeepCollectionEquality().hash(_assignees),createdAt,readBy,totalReaders,viewCount,commentCount,bookmarked,isRead,isConfirmer,confirmedByMe,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_attachments)]);

@override
String toString() {
  return 'Memo(id: $id, title: $title, content: $content, priority: $priority, category: $category, project: $project, scheduledDate: $scheduledDate, author: $author, assignees: $assignees, createdAt: $createdAt, readBy: $readBy, totalReaders: $totalReaders, viewCount: $viewCount, commentCount: $commentCount, bookmarked: $bookmarked, isRead: $isRead, isConfirmer: $isConfirmer, confirmedByMe: $confirmedByMe, comments: $comments, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$MemoCopyWith<$Res> implements $MemoCopyWith<$Res> {
  factory _$MemoCopyWith(_Memo value, $Res Function(_Memo) _then) = __$MemoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? content, String priority, String category, MemoProject? project, DateTime? scheduledDate, UserRef author, List<Assignee> assignees, DateTime createdAt, int readBy, int totalReaders, int viewCount, int commentCount, bool bookmarked, bool isRead, bool isConfirmer, bool confirmedByMe, List<Comment> comments, List<Attachment> attachments
});


@override $MemoProjectCopyWith<$Res>? get project;@override $UserRefCopyWith<$Res> get author;

}
/// @nodoc
class __$MemoCopyWithImpl<$Res>
    implements _$MemoCopyWith<$Res> {
  __$MemoCopyWithImpl(this._self, this._then);

  final _Memo _self;
  final $Res Function(_Memo) _then;

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? priority = null,Object? category = null,Object? project = freezed,Object? scheduledDate = freezed,Object? author = null,Object? assignees = null,Object? createdAt = null,Object? readBy = null,Object? totalReaders = null,Object? viewCount = null,Object? commentCount = null,Object? bookmarked = null,Object? isRead = null,Object? isConfirmer = null,Object? confirmedByMe = null,Object? comments = null,Object? attachments = null,}) {
  return _then(_Memo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as MemoProject?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef,assignees: null == assignees ? _self._assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<Assignee>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,readBy: null == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as int,totalReaders: null == totalReaders ? _self.totalReaders : totalReaders // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isConfirmer: null == isConfirmer ? _self.isConfirmer : isConfirmer // ignore: cast_nullable_to_non_nullable
as bool,confirmedByMe: null == confirmedByMe ? _self.confirmedByMe : confirmedByMe // ignore: cast_nullable_to_non_nullable
as bool,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoProjectCopyWith<$Res>? get project {
    if (_self.project == null) {
    return null;
  }

  return $MemoProjectCopyWith<$Res>(_self.project!, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res> get author {
  
  return $UserRefCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
