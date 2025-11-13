// features/theme/presentation/cubit/theme_cubit.dart
import 'package:bisky_shop/core/services/theme_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeService _themeService;

  ThemeCubit(this._themeService) : super(ThemeInitial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await _themeService.getTheme();
    emit(ThemeLoaded(theme));
  }

  Future<void> changeTheme(String theme) async {
    await _themeService.setTheme(theme);
    emit(ThemeLoaded(theme));
  }
}
