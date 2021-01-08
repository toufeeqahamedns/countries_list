import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:countries_list/bloc/countries_event.dart';
import 'package:countries_list/bloc/countries_state.dart';
import 'package:countries_list/countries_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final http.Client httpClient = http.Client();
  int _limit = 20;
  int totalCountries = 0;

  CountriesBloc() : super(CountriesState());

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is FetchCountries) {
      yield await _mapFetchCountriesToState(state);
    } else if (event is NoConnection) {
      yield state.copyWith(
        status: FetchStatus.networkFailure,
        countries: state.countries,
        hasReachedMax: _hasReachedMax(state.countries.length),
      );
    }
  }

  Future<CountriesState> _mapFetchCountriesToState(CountriesState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == FetchStatus.initial) {
        final countries = await _fetchCountries();
        return state.copyWith(
          status: FetchStatus.success,
          countries: countries,
          hasReachedMax: _hasReachedMax(state.countries.length),
        );
      }
      final countries = await _fetchCountries(state.countries.length);
      return countries.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: FetchStatus.success,
              countries: List.of(state.countries)..addAll(countries),
              hasReachedMax: _hasReachedMax(state.countries.length),
            );
    } catch (e) {
      print(e);
      return state.copyWith(status: FetchStatus.failure);
    }
  }

  Future<List<Countries>> _fetchCountries([int startIndex = 0]) async {
    print(startIndex);
    List<Countries> countries = [];
    try {
      final response = await httpClient.get(
        'https://api.first.org/data/v1/countries?offset=$startIndex&limit=$_limit',
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map;
        totalCountries = body["total"];
        if (body["data"].isNotEmpty) {
          body["data"].forEach((key, value) {
            countries.add(Countries(
                code: key as String,
                country: value["country"] as String,
                region: value["region"] as String,
                isFavorite: false));
          });
        }
      }
      return countries;
    } catch (e) {
      print(e);
      return countries;
    }
  }

  bool _hasReachedMax(int countriesCount) =>
      countriesCount < totalCountries ? false : true;
}
