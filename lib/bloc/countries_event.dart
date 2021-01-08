import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCountries extends CountriesEvent {}

class NoConnection extends CountriesEvent {}

class CountriesFetched extends CountriesEvent {}