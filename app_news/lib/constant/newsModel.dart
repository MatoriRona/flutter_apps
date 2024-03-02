class NewsModel {
  final String id_news;
  final String image;
  final String title;
  final String content;
  final String description;
  final String id_user;
  final String username;
  final String date_news;

  NewsModel(
    this.id_news,
    this.image,
    this.title,
    this.content,
    this.description,
    this.id_user,
    this.username,
    this.date_news,
  );

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      json['id_news'],
      json['image'],
      json['title'],
      json['content'],
      json['description'],
      json['id_user'],
      json['username'],
      json['date_news'], // Tetap menggunakan tipe String untuk tanggal
    );
  }
}
