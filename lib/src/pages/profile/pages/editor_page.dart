import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:whoru/src/pages/profile/controllers/editor_controller.dart';

class EditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final editorController = Get.put(EditorController());
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    editorController.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return GetBuilder<EditorController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          elevation: .0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Feather.arrow_left,
              size: _size.width / 15.0,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'My Gallary',
            style: TextStyle(
              fontSize: _size.width / 20.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Feather.more_vertical,
                size: _size.width / 16.0,
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.all(6.0),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: controller.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.chooseImage(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      image: DecorationImage(
                        image: FileImage(controller.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
