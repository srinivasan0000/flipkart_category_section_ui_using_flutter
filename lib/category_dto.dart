import 'dart:convert';

import 'package:flutter/foundation.dart';

class CategoryDto {
  String name;
  List<Group> group;
  String? imageUrl;
  String? bannerImageUrl;
  CategoryDto({
    required this.name,
    required this.group,
    this.imageUrl,
    this.bannerImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'group': group.map((x) => x.toMap()).toList(),
      'imageUrl': imageUrl,
      'bannerImageUrl': bannerImageUrl,
    };
  }

  factory CategoryDto.fromMap(Map<String, dynamic> map) {
    return CategoryDto(
      name: map['name'] ?? '',
      group: List<Group>.from(map['group']?.map((x) => Group.fromMap(x))),
      imageUrl: map['imageUrl'],
      bannerImageUrl: map['bannerImageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryDto.fromJson(String source) => CategoryDto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryDto(name: $name, group: $group, imageUrl: $imageUrl, bannerImageUrl: $bannerImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryDto && other.name == name && listEquals(other.group, group) && other.imageUrl == imageUrl && other.bannerImageUrl == bannerImageUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^ group.hashCode ^ imageUrl.hashCode ^ bannerImageUrl.hashCode;
  }
}

class Group {
  String name;
  List<String> subGroup;
  Group({
    required this.name,
    required this.subGroup,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subGroup': subGroup,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] ?? '',
      subGroup: List<String>.from(map['subGroup']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));
}
