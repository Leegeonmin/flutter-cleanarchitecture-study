import 'package:flutter_photoapp/data/data_source/result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PixabayApi {
  final http.Client client;
  static const baseUrl = 'https://pixabay.com/api/';
  static const apiKey = '31645494-99849d2438fe17bdb6f35e761';

  PixabayApi({required this.client});

  Future<Result<Iterable>> fetch(String query) async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl?key=$apiKey&q=$query&image_type=photo'));
      Map<String, dynamic> decodeJson = jsonDecode(response.body);
      Iterable items = decodeJson['hits'];
      return Result.success(items);
    } catch (e) {
      return const Result.error('네트워크 에러');
    }
  }
}
