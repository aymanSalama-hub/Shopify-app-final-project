// features/theme/presentation/cubit/theme_state.dart
part of 'theme_cubit.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final String theme;

  const ThemeLoaded(this.theme);
}
