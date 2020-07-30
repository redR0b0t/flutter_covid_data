

class CovidModel{

  String trackId;
  String lyrics;
  String name;
  String rating;
  String instrumental;
  String explicit;
  String hasLyrcis;
  String hasSubs;
  String hasSync;
  String favs;
  String albumId;
  String albumName;
  String artistId;
  String artistName;
  String url;
  String lyricUrl;
  String time;
  bool isSaved;

  CovidModel(
      {this.trackId,
        this.lyrics,
        this.name,
        this.rating,
        this.instrumental,
        this.explicit,
        this.hasLyrcis,
        this.hasSubs,
        this.hasSync,
        this.favs,
        this.albumId,
        this.albumName,
        this.artistId,
        this.artistName,
        this.url,
        this.lyricUrl,
        this.time,
        this.isSaved,});

  factory CovidModel.fromJson(Map<String, dynamic> json) {
    return CovidModel(
        trackId: json['track_id'].toString() ?? 'redr0b0t',
        name: json['track_name'].toString() ?? 'demons',
        rating: json['track_rating'].toString(),
        instrumental: json['instrumental'].toString(),
        explicit: json['explicit'].toString(),
        hasLyrcis: json['has_lyrics'].toString(),
        hasSubs: json['has_subtitles'].toString(),
        hasSync: json['has_richsync'].toString(),
        favs: json['num_favourite'].toString(),
        albumId: json['album_id'].toString(),
        albumName: json['album_name'].toString(),
        artistId: json['artist_id'].toString(),
        artistName: json['artist_name'].toString() ?? 'Imagine dragons',
        url: json['track_share_url'].toString(),
        lyricUrl: json['track_edit_url'].toString(),
        isSaved: false
    );
  }
}
