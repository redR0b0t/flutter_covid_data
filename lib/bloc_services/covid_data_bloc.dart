import '../api_data/api_repo.dart';
import '../models/covid_state_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


class CovidDataBloc {
  final _repository = Repository();
  final _covidStateFetcher = PublishSubject<CovidStateModel>();
  final _covidStateInfoFetcher = PublishSubject<CovidStateModel>();

  Stream<CovidStateModel> get allStates => _covidStateFetcher.stream;

  fetchCovidStates() async {
    CovidStateModel covidStateModel = await _repository.fetchCovidStates();
    _covidStateFetcher.sink.add(covidStateModel);
  }
  fetchCovidStateInfo(String state) async {
    CovidStateModel covidStateInfoModel = await _repository.fetchCovidStateInfo(state);
    _covidStateInfoFetcher.sink.add(covidStateInfoModel);
  }

  dispose() {
    _covidStateFetcher.close();
    _covidStateInfoFetcher.close();
  }
}

final bloc = CovidDataBloc();