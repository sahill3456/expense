part of 'user_model.dart';

UserModelAdapter _$UserModelAdapter = UserModelAdapter();

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      profilePictureUrl: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      lastLogin: fields[5] as DateTime?,
      isDarkModeEnabled: fields[6] as bool? ?? false,
      currency: fields[7] as String? ?? 'USD',
      language: fields[8] as String? ?? 'en',
      notificationsEnabled: fields[9] as bool? ?? true,
      monthlyBudget: fields[10] as double? ?? 5000,
      isSocialAuthUser: fields[11] as bool? ?? false,
      socialAuthProvider: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.profilePictureUrl)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastLogin)
      ..writeByte(6)
      ..write(obj.isDarkModeEnabled)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.language)
      ..writeByte(9)
      ..write(obj.notificationsEnabled)
      ..writeByte(10)
      ..write(obj.monthlyBudget)
      ..writeByte(11)
      ..write(obj.isSocialAuthUser)
      ..writeByte(12)
      ..write(obj.socialAuthProvider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

extension UserModelJsonExt on UserModel {
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'profilePictureUrl': profilePictureUrl,
        'createdAt': createdAt.toIso8601String(),
        'lastLogin': lastLogin?.toIso8601String(),
        'isDarkModeEnabled': isDarkModeEnabled,
        'currency': currency,
        'language': language,
        'notificationsEnabled': notificationsEnabled,
        'monthlyBudget': monthlyBudget,
        'isSocialAuthUser': isSocialAuthUser,
        'socialAuthProvider': socialAuthProvider,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      isDarkModeEnabled: json['isDarkModeEnabled'] as bool? ?? false,
      currency: json['currency'] as String? ?? 'USD',
      language: json['language'] as String? ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble() ?? 5000,
      isSocialAuthUser: json['isSocialAuthUser'] as bool? ?? false,
      socialAuthProvider: json['socialAuthProvider'] as String?,
    );
  }
}
