import 'package:flutter/material.dart';
import 'package:coviddata/pages/covid_list.dart';
import 'package:coviddata/bloc_services/check_connectivity_bloc.dart';
import 'package:coviddata/bloc_services/loading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Covid Data',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ConnectivityBloc(),
            ),
            BlocProvider(
              create: (_) => LoadingBloc(),
            ),

          ],
          child: CovidList(),
        ));
  }
}
