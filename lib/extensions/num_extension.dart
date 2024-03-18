extension NumExtension on num {
  String toQuantityString() {
    final regex = RegExp(r'([.]*0)(?!.*\d)');
    return toString().replaceAll(regex, '');
  }
}
