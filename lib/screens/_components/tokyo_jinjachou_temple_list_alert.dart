import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/temple_lat_lng/temple_lat_lng.dart';
import '../../controllers/temple_list/temple_list.dart';
import '../../extensions/extensions.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';

class TokyoJinjachouTempleListAlert extends ConsumerStatefulWidget {
  const TokyoJinjachouTempleListAlert({
    super.key,
    required this.templeVisitDateMap,
    required this.idBaseComplementTempleVisitedDateMap,
  });

  final Map<String, List<String>> templeVisitDateMap;
  final Map<String, List<DateTime>> idBaseComplementTempleVisitedDateMap;

  @override
  ConsumerState<TokyoJinjachouTempleListAlert> createState() => _TokyoJinjachouTempleListAlertState();
}

class _TokyoJinjachouTempleListAlertState extends ConsumerState<TokyoJinjachouTempleListAlert> {
  List<int> idList = <int>[];

  ///
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

    final List<String> jogaiTempleNameList = <String>[];
    final List<String> jogaiTempleAddressList = <String>[];
    final List<String> jogaiTempleAddressList2 = <String>[];

    final AsyncValue<TempleLatLngState> templeLatLngState = ref.watch(templeLatLngProvider);
    final List<TempleLatLngModel>? templeLatLngList = templeLatLngState.value?.templeLatLngList;

    if (templeLatLngList != null) {
      for (final TempleLatLngModel element in templeLatLngList) {
        jogaiTempleNameList.add(element.temple);
        jogaiTempleAddressList.add(element.address);
        jogaiTempleAddressList2.add('東京都${element.address}');
      }
    }

    final AsyncValue<TempleListState> templeListState = ref.watch(templeListProvider);
    final List<TempleListModel>? templeListList = templeListState.value?.templeListList;

    if (templeListList != null) {
      for (int i = 0; i < templeListList.length; i++) {
        if (jogaiTempleNameList.contains(templeListList[i].name)) {
          idList.add(templeListList[i].id);
        }

        if (jogaiTempleAddressList.contains(templeListList[i].address)) {
          idList.add(templeListList[i].id);
        }

        if (jogaiTempleAddressList2.contains(templeListList[i].address)) {
          idList.add(templeListList[i].id);
        }

        if (jogaiTempleAddressList.contains('東京都${templeListList[i].address}')) {
          idList.add(templeListList[i].id);
        }

        if (jogaiTempleAddressList2.contains('東京都${templeListList[i].address}')) {
          idList.add(templeListList[i].id);
        }
      }
    }

    idList = idList.toSet().toList();

    if (templeListList != null) {
      for (int i = 0; i < templeListList.length; i++) {
        List<String> dateList = <String>[];
        if (idList.contains(templeListList[i].id)) {
          if (widget.templeVisitDateMap[templeListList[i].name] != null) {
            dateList = widget.templeVisitDateMap[templeListList[i].name]!;
          } else {
            widget.idBaseComplementTempleVisitedDateMap[templeListList[i].id.toString()]
                ?.forEach((DateTime element) => dateList.add(element.yyyymmdd));
          }
        }

        list.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: (idList.contains(templeListList[i].id)) ? Colors.yellowAccent : Colors.white,
                radius: 10,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(templeListList[i].name),
                  Text(templeListList[i].address),
                  Text(dateList.length.toString()),
                ],
              ),
            ],
          ),
        ));
      }
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
