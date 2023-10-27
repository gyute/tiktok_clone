class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final String id;
  final int createdAt;
  final int likes;
  final int commnets;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.creator,
    required this.createdAt,
    required this.likes,
    required this.commnets,
  });

  VideoModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : id = videoId,
        title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        createdAt = json["createdAt"],
        likes = json["likes"],
        commnets = json["commnets"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "createdAt": createdAt,
      "likes": likes,
      "commnets": commnets,
    };
  }
}
