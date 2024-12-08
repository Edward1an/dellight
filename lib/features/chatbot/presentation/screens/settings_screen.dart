import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/app_bloc/app_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    final locale = context.read<AppBloc>().state.locale;
    _selectedLanguage = locale?.languageCode ?? 'en';
    _isDarkMode = context.read<AppBloc>().state.themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email =
        (context.read<AuthBloc>().state as AuthSuccess).userInfo.email;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/icon_logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.email),
              subtitle: Text(email),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.appLanguage),
              trailing: DropdownMenu<String>(
                initialSelection: _selectedLanguage,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'en', label: l10n.english),
                  DropdownMenuEntry(value: 'es', label: l10n.spanish),
                  DropdownMenuEntry(value: 'de', label: l10n.german),
                  DropdownMenuEntry(value: 'fr', label: l10n.french),
                ],
                onSelected: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    context
                        .read<AppBloc>()
                        .add(LocaleChanged(languageCode: _selectedLanguage));
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(l10n.darkMode),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                  context.read<AppBloc>().add(
                        ThemeModeChanged(
                          themeMode:
                              _isDarkMode ? ThemeMode.dark : ThemeMode.light,
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
