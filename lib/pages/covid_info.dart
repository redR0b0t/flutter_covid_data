import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:coviddata/api_data/api_key.dart';
import 'package:coviddata/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coviddata/utils/style_guide.dart';
import 'package:coviddata/widgets/background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coviddata/models/covid_model.dart';
import 'package:http/http.dart' as http;
import 'package:coviddata/bloc_services/check_connectivity_bloc.dart';
import 'package:coviddata/bloc_services/loading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CovidDetails extends StatefulWidget {
  final CovidModel covid;

  CovidDetails({
    this.covid,
  });

  @override
  _CovidDetailsState createState() => _CovidDetailsState();
}

class _CovidDetailsState extends State<CovidDetails> {
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
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0),
                        blurRadius: 15.0,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, -10.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Text("${widget.covid.name}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.4,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                          fontFamily: "RobotoRegular")),
                ),
                background: Image.asset("assets/covid.png")),
          ),
        ];
      }, body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Background(),
            BlocBuilder<ConnectivityBloc, bool>(builder: (_, connected) {
              if (connected == true) {
                if (widget.covid.lyrics == null) {
                  fetchCovidDetails();
                } else {
                  context.bloc<LoadingBloc>().add(LoadingEvent.off);
                }
                return BlocBuilder<LoadingBloc, bool>(builder: (_, loading) {
                  if (loading == true) {
                    return Loading();
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      //color: Colors.red,
                      child: ListView(
                        children: <Widget>[

                          descriptionCard(),
                          linksCard(),
                          lyricsCard(),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    );
                  }
                });
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
          ],
        );
      })),
    );
  }



  Widget descriptionCard() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${'Description'} :',
                style: subtitle,
              ),
            ),
            new Text(
              "covid Name:\n${widget.covid.name}\n\n"
              "Artist Name:\n${widget.covid.artistName}\n\n"
              "Album Name:\n${widget.covid.albumName}\n\n"
              "Explicit:\n${widget.covid.explicit == '0' ? "No" : "Yes"}\n\n"
              "Rating:\n${widget.covid.rating}\n\n"
              "Favourites:\n${widget.covid.favs}\n\n",
              style: description,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget linksCard() {
    return Card(
        color: Colors.white.withOpacity(0.9),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  ' Links :',
                  style: subtitle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    //color: Colors.white,

                    ),
                child: IconButton(
                  onPressed: () {
                    launch(widget.covid.url);
                  },
                  icon: Icon(FontAwesomeIcons.virus),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    //color: Colors.white,

                    ),
                child: IconButton(
                  onPressed: () {
                    launch(widget.covid.lyricUrl);
                  },
                  icon: Icon(FontAwesomeIcons.envelopeOpenText),
                ),
              ),
            ],
          ),
        ));
  }

  Widget lyricsCard() {
    return Card(
        color: Colors.white.withOpacity(0.9),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  ' Lyrics :',
                  style: subtitle,
                ),
              ),
              Text(
                widget.covid.lyrics,
                style: description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  Widget background() {
    return Center(
      child: Image.asset('assets/covid.png'),
    );
  }







  Future<void> fetchCovidDetails() async {
    http.Response response = await http.get(
        'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${widget.covid.trackId}&apikey=$apiKey');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("Lyrics response=$json");
      String lyrics = json['message']['body']['lyrics']['lyrics_body'];
      widget.covid.lyrics = lyrics;
    } else {
      throw Exception('Failed to load track data');
    }
  }


}
