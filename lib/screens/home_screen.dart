import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_temple4/extensions/extensions.dart';
import 'package:flutter_temple4/utility/utility.dart';

import '../state/temple/temple.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> yearList = [];

  List<GlobalKey> globalKeyList = [];

  Utility utility = Utility();

  ///
  @override
  void initState() {
    super.initState();

    ref.read(templeProvider.notifier).getAllTemple();

    globalKeyList = List.generate(100, (index) => GlobalKey());
  }

  ///
  Future<void> scrollToIndex(int index) async {
    final target = globalKeyList[index].currentContext!;

    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 1000),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (yearList.isEmpty) {
      makeYearList();
    }

    return DefaultTabController(
      length: yearList.length,
      child: Container(
        width: context.screenSize.width,
        height: context.screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              isScrollable: true,
              padding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              indicatorWeight: 0.1,
              tabs: _getTabs(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(child: displayTempleList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  void makeYearList() {
    yearList = [];

    ref
        .watch(templeProvider.select((value) => value.templeList))
        .forEach((element) {
      if (!yearList.contains(element.date.year)) {
        yearList.add(element.date.year);
      }
    });
  }

  List<Widget> _getTabs() {
    final list = <Widget>[];

    for (var i = 0; i < yearList.length; i++) {
      list.add(
        TextButton(
          onPressed: () {
            scrollToIndex(i);
          },
          child: Text(yearList[i].toString()),
        ),
      );
    }

    return list;
  }

  ///
  Widget displayTempleList() {
    final list = <Widget>[];

    var year = 0;
    var i = 0;
    ref
        .watch(templeProvider.select((value) => value.templeList))
        .forEach((element) {
      if (year != element.date.year) {
        list.add(Container(
          key: globalKeyList[i],
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(element.date.year.toString()),
              Container(),
            ],
          ),
        ));

        i++;
      }

      list.add(
        Card(
          color: Colors.black.withOpacity(0.3),
          child: ListTile(
            leading: SizedBox(
              width: 40,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/no_image.png',
                image: element.thumbnail,
              ),
            ),
            title: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.screenSize.height / 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(element.date.yyyymmdd),
                      ],
                    ),
                    Text(element.temple),
                    const SizedBox(height: 5),
                    Text(
                      element.memo,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            trailing: Column(
              children: [
                const Icon(Icons.ac_unit),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: utility.getLeadingBgColor(
                    month: element.date.yyyymmdd.split('-')[1],
                  ),
                  child: Text(
                    element.date.yyyymmdd.split('-')[1],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      year = element.date.year;
    });

    return SingleChildScrollView(child: Column(children: list));
  }
}
