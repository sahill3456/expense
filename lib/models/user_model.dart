import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? displayName;

  @HiveField(3)
  final String? profilePictureUrl;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? lastLogin;

  @HiveField(6)
  final bool isDarkModeEnabled;

  @HiveField(7)
  final String? currency;

  @HiveField(8)
  final String? language;

  @HiveField(9)
  final bool notificationsEnabled;

  @HiveField(10)
  final double monthlyBudget;

  @HiveField(11)
  final bool isSocialAuthUser;

  @HiveField(12)
  final String? socialAuthProvider; // google, apple, facebook

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.profilePictureUrl,
    required this.createdAt,
    this.lastLogin,
    this.isDarkModeEnabled = false,
    this.currency = 'USD',
    this.language = 'en',
    this.notificationsEnabled = true,
    this.monthlyBudget = 5000,
    this.isSocialAuthUser = false,
    this.socialAuthProvider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isDarkModeEnabled,
    String? currency,
    String? language,
    bool? notificationsEnabled,
    double? monthlyBudget,
    bool? isSocialAuthUser,
    String? socialAuthProvider,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isSocialAuthUser: isSocialAuthUser ?? this.isSocialAuthUser,
      socialAuthProvider: socialAuthProvider ?? this.socialAuthProvider,
    );
  }
}
