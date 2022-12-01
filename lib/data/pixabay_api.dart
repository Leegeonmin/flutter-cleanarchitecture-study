import 'package:flutter_photoapp/data/photo_api_repository.dart';
import 'package:flutter_photoapp/model/photo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PixabayApi implements PhotoApiRepository {
  static const baseUrl = 'https://pixabay.com/api/';
  static const apiKey = '31645494-99849d2438fe17bdb6f35e761';
  @override
  Future<List<Photo>> fetch(query, {http.Client? client}) async {
    client ??= http.Client();

    final response = await client
        .get(Uri.parse('$baseUrl?key=$apiKey&q=$query&image_type=photo'));
    Map<String, dynamic> decodeJson = jsonDecode(response.body);
    Iterable items = decodeJson['hits'];
    return items.map((e) => Photo.fromJson(e)).toList();
  }
}
