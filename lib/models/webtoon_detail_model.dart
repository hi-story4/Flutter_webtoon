class WebtoonDetailModel {
  final String title, thumb, about, genre, age;
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
}
