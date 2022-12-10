import 'package:flutter_photoapp/data/data_source/result.dart';
import 'package:flutter_photoapp/domain/model/photo.dart';

abstract class PhotoApiRepository {
  Future<Result<List<Photo>>> fetch(String query);
}
