import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class StateLogger extends ProviderObserver {
  const StateLogger();
  @override
  void didUpdateProvider(
      ProviderBase<Object?> provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container
      ) {
    Logger().i('''
{
  provider: ${provider.name ?? provider.runtimeType},
  previous: $previousValue,
  newValue: $newValue
}
''');
  }
}
