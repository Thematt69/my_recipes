extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  static const _diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  static const _nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  String get withoutDiacriticalMarks => splitMapJoin(
        '',
        onNonMatch: (char) => char.isNotEmpty && _diacritics.contains(char)
            ? _nonDiacritics[_diacritics.indexOf(char)]
            : char,
      );

  bool containsNoDiacritics(String other) => withoutDiacriticalMarks
      .toLowerCase()
      .contains(other.withoutDiacriticalMarks.toLowerCase());
}
