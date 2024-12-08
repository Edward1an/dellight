part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class ThemeModeChanged extends AppEvent {
  final ThemeMode themeMode;
  const ThemeModeChanged({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

class LocaleChanged extends AppEvent {
  final String languageCode;
  const LocaleChanged({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class ConnectivityResultChanged extends AppEvent {
  final List<ConnectivityResult> connectivityResult;
  const ConnectivityResultChanged(this.connectivityResult);

  @override
  List<Object?> get props => [connectivityResult];
}
