class UserProgress {
  final int totalWordsLearned;
  final int totalWordsCompleted;
  final int currentLevel;
  final int currentSubLevel;
  final String currentCategory;
  final List<String> learnedWords;
  final List<String> completedWords;
  final Map<String, int>
      categoryProgress; // Her kategori için tamamlanan kelime sayısı

  UserProgress({
    this.totalWordsLearned = 0,
    this.totalWordsCompleted = 0,
    this.currentLevel = 1,
    this.currentSubLevel = 1,
    this.currentCategory = 'Beginner',
    this.learnedWords = const [],
    this.completedWords = const [],
    this.categoryProgress = const {},
  });

  UserProgress copyWith({
    int? totalWordsLearned,
    int? totalWordsCompleted,
    int? currentLevel,
    int? currentSubLevel,
    String? currentCategory,
    List<String>? learnedWords,
    List<String>? completedWords,
    Map<String, int>? categoryProgress,
  }) {
    return UserProgress(
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalWordsCompleted: totalWordsCompleted ?? this.totalWordsCompleted,
      currentLevel: currentLevel ?? this.currentLevel,
      currentSubLevel: currentSubLevel ?? this.currentSubLevel,
      currentCategory: currentCategory ?? this.currentCategory,
      learnedWords: learnedWords ?? this.learnedWords,
      completedWords: completedWords ?? this.completedWords,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWordsLearned': totalWordsLearned,
      'totalWordsCompleted': totalWordsCompleted,
      'currentLevel': currentLevel,
      'currentSubLevel': currentSubLevel,
      'currentCategory': currentCategory,
      'learnedWords': learnedWords,
      'completedWords': completedWords,
      'categoryProgress': categoryProgress,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalWordsLearned: json['totalWordsLearned'] ?? 0,
      totalWordsCompleted: json['totalWordsCompleted'] ?? 0,
      currentLevel: json['currentLevel'] ?? 1,
      currentSubLevel: json['currentSubLevel'] ?? 1,
      currentCategory: json['currentCategory'] ?? 'Beginner',
      learnedWords: List<String>.from(json['learnedWords'] ?? []),
      completedWords: List<String>.from(json['completedWords'] ?? []),
      categoryProgress: Map<String, int>.from(json['categoryProgress'] ?? {}),
    );
  }

  // Seviye hesaplama metodları
  int get totalWords => totalWordsLearned + totalWordsCompleted;

  bool isLevelCompleted(int level) {
    return totalWords >= level * 20;
  }

  bool isSubLevelCompleted(int subLevel) {
    return totalWords >= subLevel * 20;
  }

  String getCategoryForLevel(int level) {
    if (level <= 25) return 'Beginner';
    if (level <= 50) return 'Elementary';
    if (level <= 75) return 'Intermediate';
    if (level <= 100) return 'Upper Intermediate';
    if (level <= 125) return 'Advanced';
    if (level <= 150) return 'Upper Advanced';
    if (level <= 175) return 'Expert';
    if (level <= 200) return 'Master';
    if (level <= 225) return 'Grandmaster';
    return 'Legendary';
  }

  int getSubLevelInCategory(int level) {
    if (level <= 25) return level;
    return ((level - 1) % 25) + 1;
  }

  int getCategoryLevel(int level) {
    if (level <= 25) return 1;
    return ((level - 1) ~/ 25) + 1;
  }
}
