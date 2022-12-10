import 'package:flutter_photoapp/domain/model/photo.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState(
    List<Photo> photos,
    bool isLoading,
  ) = _HomeState;
}
