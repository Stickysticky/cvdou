
class ImageResult {
  String _urlImage;
  String _urlSource;
  double? _price = null;

  ImageResult(this._urlImage, this._urlSource, this._price);

  String get urlImage => _urlImage;

  String get urlSource => _urlSource;

  double? get price => _price;

  static List<ImageResult> filterUniqueUrlSource(List<ImageResult> imageResults) {
    final seenUrlSources = <String>{};
    return imageResults.where((image) {
      final isUnique = !seenUrlSources.contains(image.urlSource);
      if (isUnique) {
        seenUrlSources.add(image.urlSource);
      }
      return isUnique;
    }).toList();
  }
}