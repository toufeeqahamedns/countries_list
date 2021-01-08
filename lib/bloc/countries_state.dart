import 'package:countries_list/countries_model.dart';
import 'package:equatable/equatable.dart';

enum FetchStatus { initial, success, failure, done, networkFailure }

class CountriesState extends Equatable {
  final FetchStatus status;
  final List<Countries> countries;
  final bool hasReachedMax;

  const CountriesState({
    this.status = FetchStatus.initial,
    this.countries = const <Countries>[],
    this.hasReachedMax = false,
  });

  CountriesState copyWith({
    FetchStatus status,
    List<Countries> countries,
    bool hasReachedMax,
  }) {
    return CountriesState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, countries, hasReachedMax];
}
