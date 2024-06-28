import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/tokyo_station_model.dart';
import '../../state/routing/routing.dart';
import '../function.dart';

class TempleInfoDisplayAlert extends ConsumerStatefulWidget {
  const TempleInfoDisplayAlert(
      {super.key, required this.temple, required this.from, this.station});

  final TempleData temple;
  final String from;
  final TokyoStationModel? station;

  @override
  ConsumerState<TempleInfoDisplayAlert> createState() =>
      _TempleInfoDisplayAlertState();
}

class _TempleInfoDisplayAlertState
    extends ConsumerState<TempleInfoDisplayAlert> {
  ///
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
            children: [
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: getCircleAvatarBgColor(
                      element: widget.temple,
                      ref: ref,
                    ),
                    child: Text(
                      widget.temple.mark.padLeft(2, '0'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: context.screenSize.width),
                        Text(widget.temple.name),
                        Text(widget.temple.address),
                        Text(widget.temple.latitude),
                        Text(widget.temple.longitude),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.from == 'LatLngTempleMapAlert') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(routingProvider.notifier).setRouting(
                              templeData: widget.temple,
                              station: widget.station,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.withOpacity(0.2)),
                      child: const Text('add routing'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
