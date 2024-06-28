import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../function.dart';
import 'temple_detail_map_alert.dart';

class TempleCourseDisplayAlert extends StatefulWidget {
  const TempleCourseDisplayAlert({super.key, required this.data});

  final List<TempleData> data;

  @override
  State<TempleCourseDisplayAlert> createState() =>
      _TempleCourseDisplayAlertState();
}

class _TempleCourseDisplayAlertState extends State<TempleCourseDisplayAlert> {
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
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                Column(
                  children: widget.data.map((e) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  getCircleAvatarBgColor(element: e),
                              child: Text(
                                e.mark,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.name),
                                Text(e.address),
                                const SizedBox(height: 10),
                              ],
                            )),
                          ],
                        ),
                        const Divider(color: Colors.white),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
