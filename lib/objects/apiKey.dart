class ApiKey {
  String _libId;
  String _lib;
  String _key;

  ApiKey(this._libId, this._lib, this._key);

  String get libId => _libId;

  set libId(String value) {
    _libId = value;
  }

  String get lib => _lib;

  set lib(String value) {
    _lib = value;
  }

  String get key => _key;

  set key(String value) {
    _key = value;
  }

  static ApiKey? getFromIdLib(String libId, List<ApiKey> apiKeys) {
    for(var apiKey in apiKeys){
      if(apiKey.libId == libId){
        return apiKey;
      }
    }

    return null;
  }

}