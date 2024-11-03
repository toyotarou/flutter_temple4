import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/tokyo_jinjachou_temple_model.dart';

class TokyoJinjachouTempleListAlert extends ConsumerStatefulWidget {
  const TokyoJinjachouTempleListAlert({super.key, required this.tokyoJinjachouTempleList});

  final List<TokyoJinjachouTempleModel> tokyoJinjachouTempleList;

  @override
  ConsumerState<TokyoJinjachouTempleListAlert> createState() => _TokyoJinjachouTempleListAlertState();
}

class _TokyoJinjachouTempleListAlertState extends ConsumerState<TokyoJinjachouTempleListAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Expanded(child: _displayTokyoJinjachouTempleList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayTokyoJinjachouTempleList() {
    final List<Widget> list = <Widget>[];

    for (final TokyoJinjachouTempleModel element in widget.tokyoJinjachouTempleList) {
      list.add(Text(element.name));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
