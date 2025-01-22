import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/tokyo_train/tokyo_train.dart';
import '../../models/tokyo_train_model.dart';
import '_caution_dialog.dart';

///
Widget notReachTempleTrainSelectParts(
    {required List<TokyoTrainModel> tokyoTrainList, required BuildContext context, required WidgetRef ref}) {
  final TokyoTrainState tokyoTrainState = ref.watch(tokyoTrainProvider);

  return DefaultTextStyle(
    style: const TextStyle(fontSize: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tokyoTrainList.map(
        (TokyoTrainModel element) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: Colors.greenAccent,
            controlAffinity: ListTileControlAffinity.leading,
            value: tokyoTrainState.selectTrainList.contains(element.trainNumber),
            onChanged: (bool? value) {
              if (!tokyoTrainState.selectTrainList.contains(element.trainNumber)) {
                if (tokyoTrainState.selectTrainList.isNotEmpty) {
                  caution_dialog(context: context, content: 'cant select train');

                  return;
                }
              }

              ref.read(tokyoTrainProvider.notifier).setTrainList(trainNumber: element.trainNumber);
            },
            title: Text(
              element.trainName,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          );
        },
      ).toList(),
    ),
  );
}
