
class ImageResult {
  String _urlImage;
  String _urlSource;
  double? _price = null;

  ImageResult(this._urlImage, this._urlSource, this._price);

  String get urlImage => _urlImage;

  String get urlSource => _urlSource;

  double? get price => _price;
}