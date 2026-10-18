import 'dart:io';
import 'app_config.dart';

class OSEnvironmentAppConfig implements IAppConfig {

  final _backendUrlKey = 'BACKEND_URL';
  final _openIdUrlKey = 'OPEN_ID_URL';
  final _envKey = 'ENVIRONMENT';

  OSEnvironmentAppConfig(){
    _ensureVarSet(_backendUrlKey);
    _ensureVarSet(_openIdUrlKey);
    _ensureVarSet(_envKey);
  }

  void _ensureVarSet(String varKey) {
    if(!Platform.environment.containsKey(varKey)) {
      throw Exception("Missing env var: $varKey");
    }
  }

  String _getString(String key){
    return Platform.environment[key]!;
  }

  @override
  String get openIdHomeUrl => _getString(_openIdUrlKey);

  @override
  String get backendHomeUrl => _getString(_backendUrlKey);

  @override
  String get environment => _getString(_envKey);

  @override
  String get bundleIdentifier => "me.n10v.paul.smsresender";
}