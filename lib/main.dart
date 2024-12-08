// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dellight/core/injection/dependency_injection.dart';
import 'package:dellight/features/chatbot/presentation/blocs/app_bloc/app_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:dellight/features/chatbot/presentation/screens/home_screen_wrapper.dart';
import 'package:dellight/features/chatbot/presentation/screens/login_screen.dart';
import 'package:dellight/features/chatbot/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  FlutterNativeSplash.remove();
  injectDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(const CheckLoginEvent()),
        ),
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          create: (context) => ChatMessagesBloc(),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null && locale.languageCode == 'de') {
                context.read<AppBloc>().add(
                      const LocaleChanged(languageCode: 'de'),
                    );
                return const Locale('de');
              } else if (locale != null && locale.languageCode == 'fr') {
                context.read<AppBloc>().add(
                      const LocaleChanged(languageCode: 'fr'),
                    );
                return const Locale('fr');
              } else if (locale != null && locale.languageCode == 'es') {
                context.read<AppBloc>().add(
                      const LocaleChanged(languageCode: 'es'),
                    );
                return const Locale('es');
              } else {
                context.read<AppBloc>().add(
                      const LocaleChanged(languageCode: 'en'),
                    );
                return const Locale('en');
              }
            },
            home: BlocListener<AppBloc, AppState>(
              listener: (context, state) {
                final connectivityResult = state.connectivityResult;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                if (connectivityResult.contains(ConnectivityResult.none)) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('No internet connection')),
                    );
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }
              },
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.statusCode.toString())),
                    );
                  } else if (state is AuthLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                          ),
                        ),
                      ),
                    );
                  } else if (state is AuthSuccess) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    return const HomeScreenWrapper();
                  } else {
                    return const WelcomeScreen();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
