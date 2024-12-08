import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    return Column(
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Email: ${state.userInfo.email}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Add logout functionality here when needed
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  }
                  return const Text('Not authenticated');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
