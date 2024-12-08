import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dellight/core/injection/dependency_injection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  AppBloc()
      : super(
          const AppState(
            connectivityResult: [ConnectivityResult.none],
            themeMode: ThemeMode.system,
            locale: null,
          ),
        ) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        add(ConnectivityResultChanged(result));
      },
    );
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<LocaleChanged>(_onLocaleChanged);
    on<ConnectivityResultChanged>(_onConnectivityResultChanged);
  }

  FutureOr<void> _onConnectivityResultChanged(
    ConnectivityResultChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(connectivityResult: event.connectivityResult));
  }

  FutureOr<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<AppState> emit,
  ) {
    if (!getIt.isRegistered<Locale>()) {
      final _ = getIt.registerSingleton<Locale>(Locale(event.languageCode));
    } else {
      getIt.unregister<Locale>();
      final _ = getIt.registerSingleton<Locale>(Locale(event.languageCode));
    }

    emit(state.copyWith(locale: Locale(event.languageCode)));
  }

  FutureOr<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
