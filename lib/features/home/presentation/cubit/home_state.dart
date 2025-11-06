class HomeState {}

class InitialHomeState extends HomeState {}

class LoadingHomeSTate extends HomeState {}

class SuccessHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState({required this.message});
}
