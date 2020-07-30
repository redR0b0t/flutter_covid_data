import 'dart:async';
import 'covid_states_api.dart';
import '../models/covid_state_model.dart';
import 'package:coviddata/api_data/covid_state_info.dart';

class Repository {
  final stateApiProvider = StateApiProvider();
  final stateInfoProvider=StateInfoProvider();

  Future<CovidStateModel> fetchCovidStates() => stateApiProvider.fetchStateList();
  Future<CovidStateModel> fetchCovidStateInfo(String state) => stateInfoProvider.fetchStateInfo(state);
}