import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../extensions/extensions.dart';
import '../../models/tokyo_train_model.dart';
import '../_parts/_caution_dialog.dart';

class NotReachTempleTrainSelectAlert extends ConsumerStatefulWidget {
  const NotReachTempleTrainSelectAlert(
      {super.key, required this.tokyoTrainList});

  final List<TokyoTrainModel> tokyoTrainList;

  @override
  ConsumerState<NotReachTempleTrainSelectAlert> createState() =>
      _NotReachTempleTrainSelectAlertState();
}

class _NotReachTempleTrainSelectAlertState
    extends ConsumerState<NotReachTempleTrainSelectAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Expanded(child: displayTrainCheckPanel()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTrainCheckPanel() {
    final List<Widget> list = <Widget>[];

    final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);

    for (final TokyoTrainModel element in widget.tokyoTrainList) {
      list.add(
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: Colors.greenAccent,
          controlAffinity: ListTileControlAffinity.leading,
          value: tokyoTrainState.selectTrainList.contains(element.trainNumber),
          onChanged: (bool? value) {
            if (!tokyoTrainState.selectTrainList
                .contains(element.trainNumber)) {
              if (tokyoTrainState.selectTrainList.length > 2) {
                caution_dialog(context: context, content: 'cant add train');

                return;
              }
            }

            ref
                .read(tokyoTrainProvider.notifier)
                .setTrainList(trainNumber: element.trainNumber);
          },
          title: Text(
            element.trainName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
