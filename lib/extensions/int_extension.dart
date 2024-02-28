extension IntExtension on int? {
  String? get toTimeString {
    if (this == null) return null;
    final hours = this! ~/ 60;
    final minutes = this! % 60;
    return '${hours > 0 ? '$hours h ' : ''}${minutes > 0 ? '$minutes min' : ''}';
  }
}
