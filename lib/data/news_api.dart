import '../model/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<NewsModel> getNews() async {
  var client = http.Client();
  var newsModel;
  try {
    var response = await client.get(Uri.parse(
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=7a5754849678477eb089ad811680804a"));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      newsModel = NewsModel.fromJson(jsonMap);
    }
  } catch (Exception) {
    return newsModel;
  }

  return newsModel;
}
