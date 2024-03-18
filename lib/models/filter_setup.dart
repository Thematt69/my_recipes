import 'package:equatable/equatable.dart';

class FilterSetup extends Equatable {
  const FilterSetup({
    this.minTotalTime = 0,
    this.maxTotalTime = 720,
    this.webSource = true,
    this.bookSource = true,
  });

  final int minTotalTime;
  final int maxTotalTime;
  final bool webSource;
  final bool bookSource;

  FilterSetup copyWith({
    int? minTotalTime,
    int? maxTotalTime,
    bool? webSource,
    bool? bookSource,
  }) {
    return FilterSetup(
      minTotalTime: minTotalTime ?? this.minTotalTime,
      maxTotalTime: maxTotalTime ?? this.maxTotalTime,
      webSource: webSource ?? this.webSource,
      bookSource: bookSource ?? this.bookSource,
    );
  }

  @override
  List<Object?> get props => [
        minTotalTime,
        maxTotalTime,
        webSource,
        bookSource,
      ];
}
