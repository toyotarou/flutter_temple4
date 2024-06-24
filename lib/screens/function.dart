import 'package:flutter/material.dart';

import '_components/temple_detail_alert.dart';

///
Color? getCircleAvatarBgColor({required TempleData element}) {
  switch (element.mark) {
    case 'S':
    case 'E':
    case 'S/E':
      return Colors.green[900];
    case '01':
      return Colors.redAccent;
    default:
      return Colors.orangeAccent;
  }
}
