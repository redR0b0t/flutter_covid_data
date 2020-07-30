import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:coviddata/models/covid_state_model.dart';
import 'package:coviddata/api_data/api_key.dart';

class StateInfoProvider {
  Client client = Client();
  final _apiKey = apiKey;

  Future<CovidStateModel> fetchStateInfo(String state) async {
    print("entered");
    final response = await client
        .get("http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return CovidStateModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }
}