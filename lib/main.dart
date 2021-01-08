import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:countries_list/bloc/countries_bloc.dart';
import 'package:countries_list/bloc/countries_event.dart';
import 'package:countries_list/favoritepage.dart';
import 'package:countries_list/countriespage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(create: (_) => CountriesBloc(), child: CountriesApp()));
}

class CountriesApp extends StatefulWidget {
  @override
  _CountriesAppState createState() => _CountriesAppState();
}

class _CountriesAppState extends State<CountriesApp> {
  int _currentIndex = 0;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final List<Widget> _childern = [
    CountriesPage(),
    FavoritePage(),
  ];

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countires',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _childern[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorite")
          ],
        ),
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        context.read<CountriesBloc>().add(FetchCountries());
        break;
      default:
        context.read<CountriesBloc>().add(NoConnection());
        break;
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
