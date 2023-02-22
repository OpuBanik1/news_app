import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:news_app/api/const.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/news_model.dart';
import 'package:news_app/search.dart';

class CustomHttp {
  static Future<List<Articles>> fetchApi(
      {required int page, required String sortBy}) async {
    String url =
        '$baseUrl&q=bitcoin&pageSize=10&page=$page&sortBy=$sortBy&apiKey=$token';
    List<Articles> allNewsData = [];
    Articles? articles;

    var response = await http.get(Uri.parse(url));
    // print(response.body);
    var data = jsonDecode(response.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }

    return allNewsData;
  }

  static Future<List<Articles>> searchApi({required String search}) async {
    String url = 'https://newsapi.org/v2/everything?q=$search&apiKey=$token';
    List<Articles> allNewData = [];
    Articles? articles;

    var response = await http.get(Uri.parse(url));
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    // print(response.body);
    var data = jsonDecode(response.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewData.add(articles);
    }

    return allNewData;
  }
}
