import 'app_config.dart';

class CompilationEnvironmentAppConfig implements IAppConfig {

  static const _backendHomeUrl = String.fromEnvironment('BACKEND_URL');
  static const _environment = String.fromEnvironment('ENVIRONMENT');
  static const _openIdHomeUrl = String.fromEnvironment('OPEN_ID_URL');

  @override
  String get openIdHomeUrl => _openIdHomeUrl;

  @override
  String get backendHomeUrl => _backendHomeUrl;

  @override
  String get environment => _environment;

  @override
  String get bundleIdentifier => "me.n10v.paul.smsresender";
}