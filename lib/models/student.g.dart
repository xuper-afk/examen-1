// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      cycle: (json['cycle'] as num).toInt(),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'cycle': instance.cycle,
      'photoUrl': instance.photoUrl,
    };
