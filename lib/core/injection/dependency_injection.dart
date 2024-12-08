import 'package:dellight/features/chatbot/data/repositories/auth.repository_impl.dart';
import 'package:dellight/features/chatbot/data/repositories/chat_message.repository_impl.dart';
import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';
import 'package:dellight/features/chatbot/data/sources/remote/remote_auth.source.dart';
import 'package:dellight/features/chatbot/data/sources/remote/remote_chat_message.source.dart';
import 'package:dellight/features/chatbot/domain/repositories/auth.repository.dart';
import 'package:dellight/features/chatbot/domain/repositories/chat_message.repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final getIt = GetIt.instance;

void injectDependencies() {
  getIt.registerSingleton<Client>(Client());
  injectRemoteSources();
  injectRepositories();
  if (!GetIt.instance.isRegistered<SecureStorageService>()) {
    GetIt.instance.registerSingleton(SecureStorageService());
  }
}

void injectRemoteSources() {
  getIt.registerLazySingleton<RemoteAuthSource>(
    () => RemoteAuthSource(client: getIt<Client>()),
  );
  getIt.registerLazySingleton<RemoteChatMessageSource>(
    () => RemoteChatMessageSource(client: getIt<Client>()),
  );
}

void injectRepositories() {
  getIt.registerLazySingleton<ChatMessageRepository>(
    () => ChatMessageRepositoryImpl(
      remoteChatMessageSource: getIt<RemoteChatMessageSource>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteAuthSource: getIt<RemoteAuthSource>(),
    ),
  );
}
