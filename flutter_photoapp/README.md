# flutter_photoapp

클린 아키텍처를 공부하기 위한 repository

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 11-29

- view
  - screen
    - mainview
  - component
    - photo_widget
- model
  - photo
- data
  - api
  - photo_provider

기존 구조는 view - data 로 구분하여
view에서 data class를 의존하여 view에 필요한 데이터가 늘어날 경우 view에 포함된 data class가 늘어남

-> inheritedWidget을 상속받은 PhotoProvider를 상위 위젯으로 사용하여 view가 데이터 클래스 직접 사용하는 문제 해결하고 불필요한 위젯간 데이터 전달 없이 pixabayApi 참조 가능하게함

## 11-30

- ui
  - screen
    - main
      - main_view
      - main_view_model
  - component
    - photo_widget
- model
  - photo
- data

  - pixabay_api
  - photo_provider
  - photo_api_repository

  main_view_model의 역할은 photo_provider의 비중 감소
  view의 입력을 받고 repository로 요청

  photoApiRepository는 일반화를 위한 추상 클래스
  pixabay_api는 photoApiRepository를 상속받음

## 12-1

- test

  - data
    - pixabay_api_test
    - pixabay_api_test.mocks
  - ui
    - main_view_model_test

  mokito를 사용해서 api 연결과 무관하게 test 수행(독립적)
  @GenerateMocks([type])을 적어준뒤
  flutter pub run build_runner build를 터미널에 입력하면
  .mocks 파일 생성

  사용할 메서드에는 반드시 client를 인자로 받아야함
  When 메서드 means if we add the code above in a test block, everytime arguments in When, it will always return thenAnswer()
  Verify 메서드는 a method on a mock object was called with the given arguments.

## 12-3

-photo 모델 재정의

### @JsonSerializable()

    - json으로 받아온 데이터 build_runner를 통해 자동으로 serialization
    - 변수의 이름을 변경하고 싶으면 @JsonKey(name: {바꾸고싶은 변수명})
    - 내가 할 일, 받아올 변수 만들기, factory fromJson, toJson

### Equtable

    - 서로 다른 인스턴스에 대해 판단을 쉽게 해줄 수 있는 플러그인
    - equtable을 상속받고 get props를 override해주면 끝

## 12-4

-photo 모델 재정의

### @freezed

- jsonSerilizable과 Equtable의 기능을 모두 합친 패키지
- 다만 Equtable은 인스턴스 비교와 hashCode를 가능하게하는 mixin이지만 freezed는 immutable class를 만드는 build system이라는 점
- json_serializable, copy, toString override, assert 등 편의성 기능 제공, fromJson만 작성해도 toJson기능 제공

## 12-5

-photoprovider -> Provider 라이브러리로 대체

- stream 필요 없이 notifyListeners()를 이용해 view에 전달가능
  Provider.of<viweModel>();
  context.watch<viewModel>(); 같은 방식
  context.read<viewModel>();은 뷰모델을 가져오지만 listening은 하지않음,
- Consumer<viewModel>을 이용해 rebuild가 필요한 위젯만 rebuild하게 효율적으로도 가능

-clean architecture 형태로 프로젝트 구조 변경

- data, domain, presentation

  - presentation
    - view, viewModel을 포함하는 layer
  - domain
    - usecase, repository(interface), entity(model class)를 포함하는 layer
  - data layer

    - data source, repository(implements)를 포함하는 layer

  - data_source에서 api 통신을 통해 가져온 response를 jsonDecode,
  - repo_impl에서 decoding한 데이터를 도메인 모델로 변환해서 return
  - viewModel은 전달받은 도메인 모델 가공

  - main에서 MainViewModel(repository:PhotoApiRepositoryImpl(PixabayApi(client: http.Client()))) 이러한 의존성 주입은 테스트 코드를 작성하기 용이하게한다.

## 12-6

- 에러처리
  - Result 추상 클래스 생성
    - factory keyword를 이용해 success, error 타입 생성
    - 새로운 인스턴스를 생성하지 않는 생성자를 구현할 때 factory 키워드를 사용하라고 한다. => 싱글톤
    - fetch를 통해 받아온 데이터는 try catch문을 통해 Result.success or Result.error로 리턴됨.
    - freezed를 통해 class를 빌드하면 when 메서드를 사용할 수 있음
      이를 통해 response를 성공, 실패했을 때 리턴 타입을 분기가능
    - viewModel에 Result.error가 넘어오면
      streamController를 통해 이벤트를 발생시킴
    - view에서는 initState단계에서 read(watch는 불가능)를 통해
      eventStream에서 event 포착 후 action
    - ? 굳이 스트림 컨트롤러 달지말고

## 12-7

- 상태관리
  - viewModel에 photo list인 photos와 fetch 중 로딩을 체크하는 isLoading 두가지 상태가 존재 -> viewModel이 복잡해짐
  - 상태를 따로 관리하는 Home_State 객체를 생성
  - viewModel은 Home_State 객체를 가지고 있고 getter를 통해 사용
  - Home_State를 freezed를 사용해 불변객체로 만듦(copyWith으로 값 복사)

## 12-8

- use_case 생성
  - 기존 viewModel에서 직접 repository객체를 가지고 data를 가져오던 로직을 분리하기 위해 생성
  - viewModel - usecase - repository
  - viewModel은 오로지 view와 관련된 로직이 포함되어야함
  - usecase는 business logic을 포함하며, 기능별로 하나의 클래스로만 작성해 재사용성을 높이는 게 좋음
