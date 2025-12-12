import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class BadgeModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String badgeType;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String emoji;

  @HiveField(6)
  final DateTime unlockedAt;

  @HiveField(7)
  final String? category; // spending_milestone, streak, social

  BadgeModel({
    required this.id,
    required this.userId,
    required this.badgeType,
    required this.title,
    required this.description,
    required this.emoji,
    required this.unlockedAt,
    this.category,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeModelToJson(this);

  BadgeModel copyWith({
    String? id,
    String? userId,
    String? badgeType,
    String? title,
    String? description,
    String? emoji,
    DateTime? unlockedAt,
    String? category,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      badgeType: badgeType ?? this.badgeType,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      category: category ?? this.category,
    );
  }
}

class BadgeType {
  static const String firstExpense = 'first_expense';
  static const String tenExpenses = 'ten_expenses';
  static const String hundredExpenses = 'hundred_expenses';
  static const String weekStreak = 'week_streak';
  static const String monthStreak = 'month_streak';
  static const String socialShare = 'social_share';
  static const String billSplit = 'bill_split';
  static const String budgetMaster = 'budget_master';
  static const String spendingAnalyzer = 'spending_analyzer';

  static Map<String, BadgeModel> getDefaultBadges() {
    return {
      firstExpense: BadgeModel(
        id: firstExpense,
        userId: '',
        badgeType: firstExpense,
        title: 'First Step',
        description: 'Add your first expense',
        emoji: '🎉',
        unlockedAt: DateTime.now(),
        category: 'milestone',
      ),
      tenExpenses: BadgeModel(
        id: tenExpenses,
        userId: '',
        badgeType: tenExpenses,
        title: 'Tracker Pro',
        description: 'Track 10 expenses',
        emoji: '💪',
        unlockedAt: DateTime.now(),
        category: 'milestone',
      ),
      hundredExpenses: BadgeModel(
        id: hundredExpenses,
        userId: '',
        badgeType: hundredExpenses,
        title: 'Tracking Master',
        description: 'Track 100 expenses',
        emoji: '🏆',
        unlockedAt: DateTime.now(),
        category: 'milestone',
      ),
      weekStreak: BadgeModel(
        id: weekStreak,
        userId: '',
        badgeType: weekStreak,
        title: 'Consistent',
        description: '7-day tracking streak',
        emoji: '🔥',
        unlockedAt: DateTime.now(),
        category: 'streak',
      ),
      monthStreak: BadgeModel(
        id: monthStreak,
        userId: '',
        badgeType: monthStreak,
        title: 'Dedicated',
        description: '30-day tracking streak',
        emoji: '⭐',
        unlockedAt: DateTime.now(),
        category: 'streak',
      ),
      socialShare: BadgeModel(
        id: socialShare,
        userId: '',
        badgeType: socialShare,
        title: 'Social Butterfly',
        description: 'Share your expenses on social media',
        emoji: '🦋',
        unlockedAt: DateTime.now(),
        category: 'social',
      ),
      billSplit: BadgeModel(
        id: billSplit,
        userId: '',
        badgeType: billSplit,
        title: 'Group Player',
        description: 'Split a bill with friends',
        emoji: '👥',
        unlockedAt: DateTime.now(),
        category: 'social',
      ),
      budgetMaster: BadgeModel(
        id: budgetMaster,
        userId: '',
        badgeType: budgetMaster,
        title: 'Budget Master',
        description: 'Stay under budget for a month',
        emoji: '💰',
        unlockedAt: DateTime.now(),
        category: 'achievement',
      ),
      spendingAnalyzer: BadgeModel(
        id: spendingAnalyzer,
        userId: '',
        badgeType: spendingAnalyzer,
        title: 'Spending Analyzer',
        description: 'View detailed spending insights',
        emoji: '📊',
        unlockedAt: DateTime.now(),
        category: 'achievement',
      ),
    };
  }
}
