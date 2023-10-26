class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final int createdAt;
  final int likes;
  final int commnets;

  VideoModel({
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

  Map<String, dynamic> toJson() {
    return {
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
