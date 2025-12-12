import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/badge_model.dart';
import '../services/database_service.dart';

const uuid = Uuid();

class BadgeProvider extends ChangeNotifier {
  List<BadgeModel> _userBadges = [];

  List<BadgeModel> get userBadges => _userBadges;

  void loadUserBadges(String userId) {
    _userBadges = DatabaseService.getUserBadges(userId);
    notifyListeners();
  }

  Future<void> checkAndAwardBadges(
    String userId,
    int totalExpenseCount,
    DateTime lastExpenseDate,
    int currentStreak,
    bool hasSocialShared,
    bool hasBillSplit,
  ) async {
    final today = DateTime.now();

    // First Expense Badge
    if (totalExpenseCount == 1 &&
        !DatabaseService.hasBadge(userId, BadgeType.firstExpense)) {
      await _awardBadge(
        userId,
        BadgeType.firstExpense,
        'First Step',
        'Add your first expense',
        '🎉',
        'milestone',
      );
    }

    // Ten Expenses Badge
    if (totalExpenseCount >= 10 &&
        !DatabaseService.hasBadge(userId, BadgeType.tenExpenses)) {
      await _awardBadge(
        userId,
        BadgeType.tenExpenses,
        'Tracker Pro',
        'Track 10 expenses',
        '💪',
        'milestone',
      );
    }

    // Hundred Expenses Badge
    if (totalExpenseCount >= 100 &&
        !DatabaseService.hasBadge(userId, BadgeType.hundredExpenses)) {
      await _awardBadge(
        userId,
        BadgeType.hundredExpenses,
        'Tracking Master',
        'Track 100 expenses',
        '🏆',
        'milestone',
      );
    }

    // Week Streak Badge
    if (currentStreak >= 7 &&
        !DatabaseService.hasBadge(userId, BadgeType.weekStreak)) {
      await _awardBadge(
        userId,
        BadgeType.weekStreak,
        'Consistent',
        '7-day tracking streak',
        '🔥',
        'streak',
      );
    }

    // Month Streak Badge
    if (currentStreak >= 30 &&
        !DatabaseService.hasBadge(userId, BadgeType.monthStreak)) {
      await _awardBadge(
        userId,
        BadgeType.monthStreak,
        'Dedicated',
        '30-day tracking streak',
        '⭐',
        'streak',
      );
    }

    // Social Share Badge
    if (hasSocialShared &&
        !DatabaseService.hasBadge(userId, BadgeType.socialShare)) {
      await _awardBadge(
        userId,
        BadgeType.socialShare,
        'Social Butterfly',
        'Share your expenses on social media',
        '🦋',
        'social',
      );
    }

    // Bill Split Badge
    if (hasBillSplit &&
        !DatabaseService.hasBadge(userId, BadgeType.billSplit)) {
      await _awardBadge(
        userId,
        BadgeType.billSplit,
        'Group Player',
        'Split a bill with friends',
        '👥',
        'social',
      );
    }
  }

  Future<void> _awardBadge(
    String userId,
    String badgeType,
    String title,
    String description,
    String emoji,
    String category,
  ) async {
    final badge = BadgeModel(
      id: uuid.v4(),
      userId: userId,
      badgeType: badgeType,
      title: title,
      description: description,
      emoji: emoji,
      unlockedAt: DateTime.now(),
      category: category,
    );

    await DatabaseService.addBadge(badge);
    _userBadges.add(badge);
    notifyListeners();
  }

  int getTotalBadges() => _userBadges.length;

  List<BadgeModel> getBadgesByCategory(String category) {
    return _userBadges.where((badge) => badge.category == category).toList();
  }

  bool hasBadge(String badgeType) {
    return _userBadges.any((badge) => badge.badgeType == badgeType);
  }
}
