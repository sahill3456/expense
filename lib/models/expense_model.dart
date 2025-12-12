import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  @HiveField(8)
  final bool isRecurring;

  @HiveField(9)
  final String? recurringFrequency; // daily, weekly, monthly, yearly

  @HiveField(10)
  final List<String>? sharedWith; // User IDs for bill splitting

  @HiveField(11)
  final double? splitAmount;

  @HiveField(12)
  final String? paymentMethod;

  @HiveField(13)
  final String? tags;

  @HiveField(14)
  final String? attachmentUrl;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.createdAt,
    this.updatedAt,
    this.isRecurring = false,
    this.recurringFrequency,
    this.sharedWith,
    this.splitAmount,
    this.paymentMethod,
    this.tags,
    this.attachmentUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
    String? recurringFrequency,
    List<String>? sharedWith,
    double? splitAmount,
    String? paymentMethod,
    String? tags,
    String? attachmentUrl,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      sharedWith: sharedWith ?? this.sharedWith,
      splitAmount: splitAmount ?? this.splitAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tags: tags ?? this.tags,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }
}

enum ExpenseCategory {
  foodDining('Food & Dining', '🍔'),
  fashion('Fashion', '👗'),
  entertainment('Entertainment', '🎬'),
  travel('Travel', '✈️'),
  education('Education', '📚'),
  health('Health', '🏥'),
  tech('Tech', '💻'),
  other('Other', '📦');

  final String displayName;
  final String emoji;

  const ExpenseCategory(this.displayName, this.emoji);

  static ExpenseCategory fromString(String value) {
    for (final category in ExpenseCategory.values) {
      if (category.name == value) {
        return category;
      }
    }
    return ExpenseCategory.other;
  }
}
