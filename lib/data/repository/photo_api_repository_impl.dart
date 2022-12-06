import 'package:flutter_photoapp/data/data_source/pixabay_api.dart';
import 'package:flutter_photoapp/data/data_source/result.dart';
import 'package:flutter_photoapp/domain/repository/photo_api_repository.dart';
import 'package:flutter_photoapp/domain/model/photo.dart';

class PhotoApiRepositoryImpl implements PhotoApiRepository {
  PixabayApi api;

  PhotoApiRepositoryImpl(this.api);
  @override
  Future<Result<List<Photo>>> fetch(query) async {
    final Result<Iterable> result = await api.fetch(query);
    return result.when(success: (iterable) {
      return Result.success(iterable.map((e) => Photo.fromJson(e)).toList());
    }, error: (message) {
      return Result.error(message);
    });
  }
}
