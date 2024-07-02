import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';

class TemplePhotoGalleryAlert extends ConsumerStatefulWidget {
  const TemplePhotoGalleryAlert(
      {super.key, required this.photoList, required this.number});

  final List<String> photoList;
  final int number;

  @override
  ConsumerState<TemplePhotoGalleryAlert> createState() =>
      _TemplePhotoGalleryAlertState();
}

class _TemplePhotoGalleryAlertState
    extends ConsumerState<TemplePhotoGalleryAlert> {
//  final controller = PageController(viewportFraction: 0.9);

  late PageController pageController;

  ///
  @override
  Widget build(BuildContext context) {
    pageController = PageController(initialPage: widget.number);

    final imageList = <Widget>[];
    widget.photoList.forEach((value) {
      imageList.add(Image.network(value));
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black.withOpacity(0.6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: imageList.length,
                controller: pageController,
                itemBuilder: (_, index) {
                  final exName = widget.photoList[index].split('/');
                  final exFileName = exName[exName.length - 1].split('.');
                  final exDateTime = exFileName[0].split('_');

                  var dispTime = '--:--';
                  if (exDateTime.length == 2) {
                    final hour = exDateTime[1].substring(0, 2);
                    final minute = exDateTime[1].substring(2, 4);

                    dispTime = '$hour:$minute';
                  }

                  return Column(
                    children: [
                      SizedBox(
                          height: context.screenSize.height * 0.7,
                          child: imageList[index]),
                      const SizedBox(height: 20),
                      Text(
                        dispTime,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
