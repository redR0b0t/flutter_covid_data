import 'dart:convert';
import 'dart:async';
import 'package:coviddata/api_data/api_key.dart';
import 'package:coviddata/models/covid_model.dart';
import 'package:coviddata/models/covid_state_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coviddata/bloc_services/check_connectivity_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coviddata/widgets/covid_card.dart';
import 'package:coviddata/widgets/loading.dart';
import 'package:coviddata/widgets/background.dart';
import 'package:connectivity/connectivity.dart';

//import 'package:coviddata/pages/api_error.dart';
import 'package:coviddata/widgets/empty_card.dart';
import 'package:coviddata/bloc_services/loading_bloc.dart';
import 'package:coviddata/bloc_services/covid_data_bloc.dart';

class CovidList extends StatefulWidget {
  @override
  _CovidListState createState() => _CovidListState();
}

class _CovidListState extends State<CovidList> {
  List<CovidModel> covid;
  StreamSubscription subscription;

  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        context.bloc<ConnectivityBloc>().add(ConnectivityEvent.off);
      } else {
        context.bloc<ConnectivityBloc>().add(ConnectivityEvent.on);
      }
    });
  }

  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Covid List"),
        centerTitle: true,
      ),


      body: Stack(children: <Widget>[
        Background(),
        BlocBuilder<ConnectivityBloc, bool>(builder: (_, connected) {
          if (connected == true) {
            covid ?? fetchCovid();
            return _streamcovid();
          } else {
            return Center(
                child: Chip(
                    label: Text(
              "Not Connected",
              style: TextStyle(color: Colors.purple, fontSize: 30),
              textAlign: TextAlign.center,
            )));
          }
        })
      ]),
    );
  }

//  Widget _streamcovid() {
//    return BlocBuilder<LoadingBloc, bool>(builder: (_, loading) {
//      if (loading == true) {
//        return Loading();
//      } else {
//        return covid.length == 0
//            ? EmptyCard(type: "Tracks(APIkey Error")
//            : ListView.builder(
//                itemCount: covid.length,
//                itemBuilder: (context, index) {
//                  print(covid[index].name);
//                  return CovidCard(
//                    covid: covid[index],
//                  );
//                });
//      }
//    });
//  }
  Widget _streamcovid() {
    return StreamBuilder(
      stream: bloc.allStates,
      builder: (context, AsyncSnapshot<CovidStateModel> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  Widget buildList(AsyncSnapshot<CovidStateModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.trackId.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            'https://image.tmdb.org/t/p/w185${snapshot.data
                .trackId[index]}',
            fit: BoxFit.cover,
          );
        });
  }

  void fetchCovid() async {
    http.Response response = await http.get(
        'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$apiKey');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var message = json['message'];

      var body = message['body'];
      List tracksJSON = [];
      if (body.length == 0) {
        print("api error");
        print("response body is null");
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ApiError()));
      } else {
        tracksJSON = body['track_list'];
        print(tracksJSON[3]);
      }
      covid = (tracksJSON).map((i) => CovidModel.fromJson(i['track'])).toList();
      context.bloc<LoadingBloc>().add(LoadingEvent.off);
    } else {
      throw Exception('Failed to load tracks');
    }
  }


}
