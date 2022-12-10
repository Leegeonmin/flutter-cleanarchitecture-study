import 'package:flutter/material.dart';
import 'package:flutter_photoapp/data/data_source/pixabay_api.dart';
import 'package:flutter_photoapp/data/repository/photo_api_repository_impl.dart';
import 'package:flutter_photoapp/domain/use_case/get_photos_use_case.dart';
import 'package:flutter_photoapp/presentation/main/main_view.dart';
import 'package:flutter_photoapp/presentation/main/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ChangeNotifierProvider(
          create: (_) => MainViewModel(
              getPhotosUseCase: GetPhotosUseCase(
                  PhotoApiRepositoryImpl(PixabayApi(client: http.Client())))),
          child: const MainPage()),
    );
  }
}
