import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_progress.dart';

class ProgressProvider extends ChangeNotifier {
  static const String _progressKey = 'user_progress';

  UserProgress _userProgress = UserProgress();

  UserProgress get userProgress => _userProgress;

  ProgressProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      try {
        final progressMap = json.decode(progressJson);
        _userProgress = UserProgress.fromJson(progressMap);
        notifyListeners();
      } catch (e) {
        print('Error loading progress: $e');
      }
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = json.encode(_userProgress.toJson());
    await prefs.setString(_progressKey, progressJson);
  }

  Future<void> addLearnedWord(String word) async {
    if (!_userProgress.learnedWords.contains(word)) {
      final newLearnedWords = List<String>.from(_userProgress.learnedWords)
        ..add(word);
      final newTotalWordsLearned = _userProgress.totalWordsLearned + 1;

      _userProgress = _userProgress.copyWith(
        learnedWords: newLearnedWords,
        totalWordsLearned: newTotalWordsLearned,
      );

      await _updateLevel();
      await _saveProgress();
      notifyListeners();
    }
  }

  Future<void> addCompletedWord(String word) async {
    if (!_userProgress.completedWords.contains(word)) {
      final newCompletedWords = List<String>.from(_userProgress.completedWords)
        ..add(word);
      final newTotalWordsCompleted = _userProgress.totalWordsCompleted + 1;

      _userProgress = _userProgress.copyWith(
        completedWords: newCompletedWords,
        totalWordsCompleted: newTotalWordsCompleted,
      );

      await _updateLevel();
      await _saveProgress();
      notifyListeners();
    }
  }

  Future<void> _updateLevel() async {
    final totalWords = _userProgress.totalWords;
    final newLevel = (totalWords ~/ 20) + 1;
    final newCategory = _userProgress.getCategoryForLevel(newLevel);
    final newSubLevel = _userProgress.getSubLevelInCategory(newLevel);

    if (newLevel != _userProgress.currentLevel) {
      _userProgress = _userProgress.copyWith(
        currentLevel: newLevel,
        currentSubLevel: newSubLevel,
        currentCategory: newCategory,
      );
    }
  }

  List<Map<String, dynamic>> getLevelsForCategory(String category) {
    final levels = <Map<String, dynamic>>[];
    final categoryStartLevel = _getCategoryStartLevel(category);

    for (int i = 1; i <= 25; i++) {
      final level = categoryStartLevel + i - 1;
      final isCompleted = _userProgress.isLevelCompleted(level);
      final isCurrentLevel = level == _userProgress.currentLevel;

      levels.add({
        'level': level,
        'subLevel': i,
        'title': category,
        'color': _getLevelColor(category, i),
        'status':
            isCompleted ? 'done' : (isCurrentLevel ? 'current' : 'locked'),
        'isUnlocked': isCompleted ||
            isCurrentLevel ||
            _userProgress.isLevelCompleted(level - 1),
      });
    }

    return levels;
  }

  int _getCategoryStartLevel(String category) {
    switch (category) {
      case 'Beginner':
        return 1;
      case 'Elementary':
        return 26;
      case 'Intermediate':
        return 51;
      case 'Upper Intermediate':
        return 76;
      case 'Advanced':
        return 101;
      case 'Upper Advanced':
        return 126;
      case 'Expert':
        return 151;
      case 'Master':
        return 176;
      case 'Grandmaster':
        return 201;
      case 'Legendary':
        return 226;
      default:
        return 1;
    }
  }

  Color _getLevelColor(String category, int subLevel) {
    final colors = [
      const Color(0xFF536DFE), // Mavi
      const Color(0xFFFFA726), // Turuncu
      const Color(0xFFEF5350), // Kırmızı
      const Color(0xFF66BB6A), // Yeşil
      const Color(0xFFAB47BC), // Mor
    ];

    return colors[(subLevel - 1) % colors.length];
  }

  List<String> getAllCategories() {
    return [
      'Beginner',
      'Elementary',
      'Intermediate',
      'Upper Intermediate',
      'Advanced',
      'Upper Advanced',
      'Expert',
      'Master',
      'Grandmaster',
      'Legendary',
    ];
  }

  String getCategoryDisplayName(String category) {
    switch (category) {
      case 'Beginner':
        return 'Başlangıç';
      case 'Elementary':
        return 'Temel';
      case 'Intermediate':
        return 'Orta';
      case 'Upper Intermediate':
        return 'İleri Orta';
      case 'Advanced':
        return 'İleri';
      case 'Upper Advanced':
        return 'Çok İleri';
      case 'Expert':
        return 'Uzman';
      case 'Master':
        return 'Usta';
      case 'Grandmaster':
        return 'Büyük Usta';
      case 'Legendary':
        return 'Efsane';
      default:
        return category;
    }
  }

  double getCategoryProgress(String category) {
    final categoryStartLevel = _getCategoryStartLevel(category);
    final categoryEndLevel = categoryStartLevel + 24;
    final totalWordsInCategory = 25 * 20; // 25 seviye * 20 kelime

    int wordsInCategory = 0;
    for (int level = categoryStartLevel; level <= categoryEndLevel; level++) {
      if (_userProgress.isLevelCompleted(level)) {
        wordsInCategory += 20;
      } else {
        final remainingWords = _userProgress.totalWords - (level - 1) * 20;
        if (remainingWords > 0) {
          wordsInCategory += remainingWords.clamp(0, 20);
        }
        break;
      }
    }

    return wordsInCategory / totalWordsInCategory;
  }
}
