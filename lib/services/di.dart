//
// DI.dart
// Service Locator for Dependency Injection (Simple, Lightweight)
//
// Created by Paul N on 04.11.2025
//

/// Simple Service Locator / Dependency Injection container for Dart.
///
/// Usage:
///   DI.register<DatabaseScannerService>(MacDatabaseScannerService());
///   final service = DI.resolve<DatabaseScannerService>()!;
///
class DI {
  // Private constructor – singleton
  DI._();

  /// Shared instance
  static final DI _instance = DI._();
  static DI get shared => _instance;

  /// Internal map of registered dependencies
  final Map<Type, Object> _registrations = {};

  /// Register an instance as a singleton
  static void register<T extends Object>(T instance) {
    _instance._registrations[T] = instance;
  }

  /// Register a factory that creates a new instance each time (if needed later)
  /// Not cached by default unless you call it once and store result
  static void registerFactory<T>(T Function() factory) {
    _instance._registrations[T] = factory;
  }

  /// Resolve a registered dependency
  /// Returns `null` if not found
  static T? resolve<T extends Object>() {
    final reg = _instance._registrations[T];
    if (reg is T) return reg;
    if (reg is Function) {
      final instance = reg() as T;
      // Optionally cache it (turn factory into singleton)
      _instance._registrations[T] = instance;
      return instance;
    }
    return null;
  }

  /// Resolve a dependency or throw a meaningful error
  /// Use during app startup for critical services
  static T resolveOrCrash<T extends Object>({String? name, String source = 'DI'}) {
    final instance = resolve<T>();
    if (instance != null) return instance;

    final typeName = T.toString();
    final detail = name != null ? '$typeName ($name)' : typeName;
    throw StateError(
      '[$source] Dependency not registered: $detail\n'
      'Did you forget to call DI.register<$typeName>(...)?',
    );
  }
}