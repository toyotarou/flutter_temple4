import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_temple4/extensions/extensions.dart';

import '../models/common/temple_data.dart';

///
Color? getCircleAvatarBgColor({required TempleData element}) {
  switch (element.mark) {
    case 'S':
    case 'E':
    case 'S/E':
    case '0':
      return Colors.green[900]?.withOpacity(0.5);
    case '01':
      return Colors.redAccent.withOpacity(0.5);
    default:
      if (element.cnt > 0) {
        return Colors.pinkAccent.withOpacity(0.5);
      }

      return Colors.orangeAccent.withOpacity(0.5);
  }
}

///
Map<String, dynamic> makeBounds({required List<TempleData> data}) {
  final latList = <double>[];
  final lngList = <double>[];

  data.forEach((element) {
    latList.add(element.latitude.toDouble());
    lngList.add(element.longitude.toDouble());
  });

  if (latList.isNotEmpty && lngList.isNotEmpty) {
    final minLat = latList.reduce(min);
    final maxLat = latList.reduce(max);
    final minLng = lngList.reduce(min);
    final maxLng = lngList.reduce(max);

    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final small = (latDiff < lngDiff) ? latDiff : lngDiff;

    final boundsLatLngMap = {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLng': minLng,
      'maxLng': maxLng,
    };

    return {'boundsLatLngMap': boundsLatLngMap, 'boundsInner': small};
  }

  return {};
}
