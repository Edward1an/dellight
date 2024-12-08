part of 'app_bloc.dart';

class AppState extends Equatable {
  final ThemeMode themeMode;
  final Locale? locale;
  final List<ConnectivityResult> connectivityResult;

  const AppState({
    required this.connectivityResult,
    required this.themeMode,
    required this.locale,
  });

  AppState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    List<ConnectivityResult>? connectivityResult,
  }) {
    return AppState(
      connectivityResult: connectivityResult ?? this.connectivityResult,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, connectivityResult];
}
