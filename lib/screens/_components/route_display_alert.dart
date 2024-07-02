import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';

class RouteDisplayAlert extends ConsumerStatefulWidget {
  const RouteDisplayAlert({super.key});

  @override
  ConsumerState<RouteDisplayAlert> createState() => _RouteDisplayAlertState();
}

class _RouteDisplayAlertState extends ConsumerState<RouteDisplayAlert> {
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
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('RouteDisplayAlert'),
            ],
          ),
        ),
      ),
    );
  }
}
