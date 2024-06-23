enum APIPath {
  getAllTemple,
  getTempleLatLng,
  getAllStation,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getAllTemple:
        return 'getAllTemple';
      case APIPath.getTempleLatLng:
        return 'getTempleLatLng';
      case APIPath.getAllStation:
        return 'getAllStation';
    }
  }
}
