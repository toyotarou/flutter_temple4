import 'package:flutter/material.dart';
import 'package:flutter_temple4/screens/_components/temple_detail_map_alert.dart';

import '../../extensions/extensions.dart';

class TempleInfoDisplayAlert extends StatefulWidget {
  const TempleInfoDisplayAlert({super.key, required this.temple});

  final TempleData temple;

  @override
  State<TempleInfoDisplayAlert> createState() => _TempleInfoDisplayAlertState();
}

class _TempleInfoDisplayAlertState extends State<TempleInfoDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Text(widget.temple.name),
            Text(widget.temple.address),
            Text(widget.temple.latitude),
            Text(widget.temple.longitude),
          ],
        ),
      ),
    );
  }
}
