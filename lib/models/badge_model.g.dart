part of 'badge_model.dart';

BadgeModelAdapter _$BadgeModelAdapter = BadgeModelAdapter();

class BadgeModelAdapter extends TypeAdapter<BadgeModel> {
  @override
  final typeId = 2;

  @override
  BadgeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return BadgeModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      badgeType: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      emoji: fields[5] as String,
      unlockedAt: fields[6] as DateTime,
      category: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.badgeType)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.emoji)
      ..writeByte(6)
      ..write(obj.unlockedAt)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

extension BadgeModelJsonExt on BadgeModel {
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'badgeType': badgeType,
        'title': title,
        'description': description,
        'emoji': emoji,
        'unlockedAt': unlockedAt.toIso8601String(),
        'category': category,
      };

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      badgeType: json['badgeType'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      category: json['category'] as String?,
    );
  }
}
