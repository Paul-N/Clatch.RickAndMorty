import 'app_config.dart';

class CompilationEnvironmentAppConfig implements IAppConfig {

  static const _backendHomeUrl = String.fromEnvironment('BACKEND_URL');
  static const _environment = String.fromEnvironment('ENVIRONMENT');

  @override
  String get backendHomeUrl => _backendHomeUrl;

  @override
  String get environment => _environment;

  @override
  String get bundleIdentifier => "app.clatch.rickandmorty";
}