import 'package:flutter_photoapp/data/data_source/result.dart';
import 'package:flutter_photoapp/domain/repository/photo_api_repository.dart';
import 'package:flutter_photoapp/domain/model/photo.dart';
import 'package:flutter_photoapp/domain/use_case/get_photos_use_case.dart';
import 'package:flutter_photoapp/presentation/main/main_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Stream이 잘 동작해야한다', () async {
    // !! PixabayApi에 의존되고 있음
    final viewModel = MainViewModel(
        getPhotosUseCase: GetPhotosUseCase(FakePhotoApiRepository()));
    await viewModel.fetch('apple');
    final List<Photo> result = fakeJson.map((e) => Photo.fromJson(e)).toList();

    expect(viewModel.state.photos, result);
  });
}

class FakePhotoApiRepository extends PhotoApiRepository {
  @override
  Future<Result<List<Photo>>> fetch(String query) async {
    Future.delayed(const Duration(microseconds: 500));
    return Result.success(fakeJson.map((e) => Photo.fromJson(e)).toList());
  }
}

List<Map<String, dynamic>> fakeJson = [
  {
    "id": 2295434,
    "pageURL":
        "https://pixabay.com/photos/spring-bird-bird-tit-spring-blue-2295434/",
    "type": "photo",
    "tags": "spring bird, bird, tit",
    "previewURL":
        "https://cdn.pixabay.com/photo/2017/05/08/13/15/spring-bird-2295434_150.jpg",
    "previewWidth": 150,
    "previewHeight": 99,
    "webformatURL":
        "https://pixabay.com/get/g87354158417f25aa51f7eb03345180f50494f2e09cec15d1a3fe6c4c6fceeb6d7b34e3072413e51af88ff23db1c3bf2534990709b6d3570a98f660352d99809f_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 426,
    "largeImageURL":
        "https://pixabay.com/get/g0e7e19e7a1f8b02accbc1e1df6d3953784972ca318ba98759b46c8fab7439fe471497077bc038b3c6ad94fc4ddf814cce090cf6efeed9320732fe0f18660fa73_1280.jpg",
    "imageWidth": 5363,
    "imageHeight": 3575,
    "imageSize": 2938651,
    "views": 585492,
    "downloads": 330733,
    "collections": 2011,
    "likes": 1950,
    "comments": 243,
    "user_id": 334088,
    "user": "JillWellington",
    "userImageURL":
        "https://cdn.pixabay.com/user/2018/06/27/01-23-02-27_250x250.jpg"
  },
  {
    "id": 3063284,
    "pageURL":
        "https://pixabay.com/photos/rose-flower-petal-floral-noble-3063284/",
    "type": "photo",
    "tags": "rose, flower, petal",
    "previewURL":
        "https://cdn.pixabay.com/photo/2018/01/05/16/24/rose-3063284_150.jpg",
    "previewWidth": 150,
    "previewHeight": 99,
    "webformatURL":
        "https://pixabay.com/get/g848d0abbd4749269c507951f2c56d39fefe7f5abfcd09df69667524aa6d37eb4c08fd431396461fb5f77071dbac33690c332d24a4c4608e3ebf2f885a5aaf295_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 426,
    "largeImageURL":
        "https://pixabay.com/get/ga386c03db81d53c3ee7cad2553f305af262fb8fdf76d031fd53c2a8bf46e9ee01599821e221fcdbc524e7b8c219ea75e399fae18ef4f3ffc4a0c7aff1d28cbd1_1280.jpg",
    "imageWidth": 6000,
    "imageHeight": 4000,
    "imageSize": 3574625,
    "views": 1022309,
    "downloads": 659290,
    "collections": 1379,
    "likes": 1513,
    "comments": 329,
    "user_id": 1564471,
    "user": "anncapictures",
    "userImageURL":
        "https://cdn.pixabay.com/user/2015/11/27/06-58-54-609_250x250.jpg"
  }
];
