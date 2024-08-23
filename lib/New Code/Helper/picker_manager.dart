class ImagePickerManager {
  ImagePickerManager._privateConstructor();

  static final ImagePickerManager _instance =
  ImagePickerManager._privateConstructor();

  factory ImagePickerManager() {
    return _instance;
  }

  bool _isPickerActive = false;

  bool get isPickerActive => _isPickerActive;

  set isPickerActive(bool value) {
    _isPickerActive = value;
  }
}
