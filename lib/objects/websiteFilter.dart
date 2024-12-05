class WebsiteFilter {
  String _lib;
  bool _isChecked;
  String _url;

  // Constructeur corrigé
  WebsiteFilter(this._lib, this._url, [this._isChecked = false]);

  // Getters
  bool get isChecked => _isChecked;
  String get lib => _lib;
  String get url => _url;

  @override
  String toString() {
    return _lib;
  }

  set isChecked(bool value) {
    _isChecked = value;
  }

  set url(String value) {
    _url = value;
  }

  set lib(String value) {
    _lib = value;
  }
}
