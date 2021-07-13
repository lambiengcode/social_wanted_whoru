import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:firexcode/firexcode.dart';
import 'package:whoru/src/helpers/editor_pro/modules/all_emojies.dart';
import 'package:whoru/src/helpers/editor_pro/modules/bottombar_container.dart';
import 'package:whoru/src/helpers/editor_pro/modules/emoji.dart';
import 'package:whoru/src/helpers/editor_pro/modules/sliders.dart';
import 'package:whoru/src/helpers/editor_pro/modules/text.dart';
import 'package:whoru/src/helpers/editor_pro/modules/textview.dart';
import 'package:whoru/src/themes/app_colors.dart';
import 'package:whoru/src/themes/font_family.dart';
import 'dart:math' as math;
import 'package:whoru/src/utils/sizer/sizer.dart';

import 'modules/color_filter_generator.dart';
import 'modules/colors_picker.dart'; // import this

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
List<Map> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final List<File> images;
  final int initialIndex;
  final Color appBarColor;
  final Color bottomBarColor;
  final Directory pathSave;
  final double pixelRatio;
  ImageEditorPro({
    this.appBarColor,
    this.bottomBarColor,
    this.pathSave,
    this.pixelRatio,
    this.images,
    this.initialIndex = 0,
  });

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  initialOpenImage() async {
    var decodedImage = await decodeImageFromList(
        File(widget.images[widget.initialIndex].path).readAsBytesSync());

    setState(() {
      height = decodedImage.height;
      width = decodedImage.width;
      _image = File(widget.images[widget.initialIndex].path);
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();

    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;
    initialOpenImage();
    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;
  bool isVertical = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Screenshot(
        controller: screenshotController,
        child: Column(
          children: [
            Container(
              height: 5.sp,
              color: colorPrimaryBlack,
            ),
            Divider(
              height: .2,
              thickness: .2,
              color: Colors.white12,
            ),
            Expanded(
              child: Container(
                width: 100.w,
                height: isVertical
                    ? (height.toDouble() / width.toDouble()) * 100.w
                    : (width.toDouble() / height.toDouble()) * 100.w,
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: rotateValue,
                  child: imageFilterLatest(
                    hue: hueValue,
                    brightness: brightnessValue,
                    saturation: saturationValue,
                    child: RepaintBoundary(
                        key: globalKey,
                        child: xStack.list(
                          [
                            _image != null
                                ? Transform(
                                    alignment: Alignment.topCenter,
                                    transform: Matrix4.rotationY(flipValue),
                                    child: ClipRect(
                                      // <-- clips to the 200x200 [Container] below

                                      child: _image.path
                                          .decorationIFToFitHeight()
                                          .xContainer(
                                              padding: EdgeInsets.zero,
                                              width: 100.w,
                                              height: isVertical
                                                  ? (height.toDouble() /
                                                          width.toDouble()) *
                                                      100.w
                                                  : (width.toDouble() /
                                                          height.toDouble()) *
                                                      100.w,
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: blurValue,
                                                  sigmaY: blurValue,
                                                ),
                                                child: Container(
                                                  color: colorValue.withOpacity(
                                                      opacityValue),
                                                ),
                                              )),
                                    ),
                                  )

                                //  BackdropFilter(
                                //     filter: ImageFilter.blur(
                                //         sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.clamp),
                                //     child: Image.file(
                                //       _image,
                                //       height: height.toDouble(),
                                //       width: width.toDouble(),
                                //       fit: BoxFit.cover,
                                //     ),
                                //   )
                                : Container(),
                            Signat().xGesture(
                              onPanUpdate: (DragUpdateDetails details) {
                                setState(() {
                                  RenderBox object = context.findRenderObject();
                                  var _localPosition = object
                                      .globalToLocal(details.globalPosition);
                                  _points = List.from(_points)
                                    ..add(_localPosition);
                                });
                              },
                              onPanEnd: (DragEndDetails details) {
                                _points.add(null);
                              },
                            ).xContainer(
                              padding: EdgeInsets.all(0.0),
                              width: 100.w,
                              height: isVertical
                                  ? (height.toDouble() / width.toDouble()) *
                                      100.w
                                  : (width.toDouble() / height.toDouble()) *
                                      100.w,
                            ),
                            xStack.list(
                              widgetJson.asMap().entries.map((f) {
                                return type[f.key] == 1
                                    ? EmojiView(
                                        left: offsets[f.key].dx,
                                        top: offsets[f.key].dy,
                                        ontap: () {
                                          scaf.currentState
                                              .showBottomSheet((context) {
                                            return Sliders(
                                              index: f.key,
                                              mapValue: f.value,
                                            );
                                          });
                                        },
                                        onpanupdate: (details) {
                                          setState(() {
                                            offsets[f.key] = Offset(
                                                offsets[f.key].dx +
                                                    details.delta.dx,
                                                offsets[f.key].dy +
                                                    details.delta.dy);
                                          });
                                        },
                                        mapJson: f.value,
                                      )
                                    : type[f.key] == 2
                                        ? TextView(
                                            left: offsets[f.key].dx,
                                            top: offsets[f.key].dy,
                                            ontap: () {
                                              showModalBottomSheet(
                                                  shape: BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10))
                                                      .xShapeBorder(),
                                                  context: context,
                                                  builder: (context) {
                                                    return Sliders(
                                                      index: f.key,
                                                      mapValue: f.value,
                                                    );
                                                  });
                                            },
                                            onpanupdate: (details) {
                                              setState(() {
                                                offsets[f.key] = Offset(
                                                    offsets[f.key].dx +
                                                        details.delta.dx,
                                                    offsets[f.key].dy +
                                                        details.delta.dy);
                                              });
                                            },
                                            mapJson: f.value,
                                          )
                                        : Container();
                              }).toList(),
                            )
                          ],
                        )).toContainer(
                      color: colorPrimaryBlack,
                      width: 100.w,
                      height: isVertical
                          ? (height.toDouble() / width.toDouble()) * 100.w
                          : (width.toDouble() / height.toDouble()) * 100.w,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: .2,
              thickness: .2,
              color: Colors.white12,
            ),
          ],
        ),
      ).xCenter().xScaffold(
          key: scaf,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Feather.arrow_left,
                color: mC,
                size: 20.sp,
              ),
            ),
            actions: <Widget>[
              // Icon(FontAwesomeIcons.boxes).xIconButton(onPressed: () {
              //   showCupertinoDialog(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: 'Select Height Width'.text(),
              //           actions: <Widget>[
              //             () {
              //               setState(() {
              //                 height = int.parse(heightcontroler.text);
              //                 width = int.parse(widthcontroler.text);
              //               });
              //               heightcontroler.clear();
              //               widthcontroler.clear();
              //               Navigator.pop(context);
              //             }.xFlatButton(child: 'Done'.text()),
              //           ],
              //           content: SingleChildScrollView(
              //             child: xColumnSS.list(
              //               [
              //                 'Define Height'.text(),
              //                 10.0.sizedHeight(),
              //                 TextField(
              //                     controller: heightcontroler,
              //                     keyboardType: TextInputType.numberWithOptions(),
              //                     decoration: InputDecoration(
              //                         hintText: 'Height',
              //                         contentPadding: EdgeInsets.only(left: 10),
              //                         border: OutlineInputBorder())),
              //                 10.0.sizedHeight(),
              //                 'Define Width'.text(),
              //                 10.0.sizedHeight(),
              //                 TextField(
              //                     controller: widthcontroler,
              //                     keyboardType: TextInputType.numberWithOptions(),
              //                     decoration: InputDecoration(
              //                         hintText: 'Width',
              //                         contentPadding: EdgeInsets.only(left: 10),
              //                         border: OutlineInputBorder())),
              //               ],
              //             ),
              //           ),
              //         );
              //       });
              // }),
              // Icon(Icons.clear).xIconButton(onPressed: () {
              //   _controller.points.clear();
              //   setState(() {});
              // }),

              GestureDetector(
                onTap: () {
                  _controller.clear();
                  //  type.clear();
                  // // fontsize.clear();
                  //  offsets.clear();
                  // // multiwidget.clear();
                  howmuchwidgetis = 0;
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.eraser,
                      color: mC,
                      size: 14.sp,
                    ),
                    SizedBox(height: 3.5.sp),
                    Text('Eraser',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: FontFamily.lato,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 20.sp),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: 'Pick a color!'.text(),
                        content: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ).xSingleChildScroolView(),
                        actions: <Widget>[
                          'Got it'.text().xFlatButton(
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              back(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: mC,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.sp),
                    Text('Paint',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: FontFamily.lato,
                          color: mC,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 20.sp),
              GestureDetector(
                onTap: () async {
                  var value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextEditorImage()));
                  if (value['name'] == null) {
                    print('true');
                  } else {
                    type.add(2);
                    widgetJson.add(value);
                    // fontsize.add(20);
                    offsets.add(Offset.zero);
                    //  colorList.add(value['color']);
                    //    multiwidget.add(value['name']);
                    howmuchwidgetis++;
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.text_fields,
                      color: mC,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.sp),
                    Text('Text',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: FontFamily.lato,
                          color: mC,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 20.sp),
              GestureDetector(
                onTap: () async {
                  var getemojis = showModalBottomSheet(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      context: context,
                      builder: (BuildContext context) {
                        return Emojies();
                      });
                  getemojis.then((value) {
                    if (value['name'] != null) {
                      type.add(1);
                      widgetJson.add(value);
                      //    fontsize.add(20);
                      offsets.add(Offset.zero);
                      //  multiwidget.add(value);
                      howmuchwidgetis++;
                    }
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: mC,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.sp),
                    Text('Emoji',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: FontFamily.lato,
                          color: mC,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 25.sp),
              GestureDetector(
                onTap: () async {
                  screenshotController
                      .capture(pixelRatio: widget.pixelRatio ?? 1.5)
                      .then((binaryIntList) async {
                    //print("Capture Done");

                    final paths =
                        widget.pathSave ?? await getTemporaryDirectory();

                    final file = await File('${paths.path}/' +
                            DateTime.now().toString() +
                            '.jpg')
                        .create();
                    file.writeAsBytesSync(binaryIntList);
                    Navigator.pop(context, file);
                  }).catchError((onError) {
                    print(onError);
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: colorPrimary,
                      size: 16.sp,
                    ),
                    SizedBox(height: 2.sp),
                    Text('Save',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: FontFamily.lato,
                          color: colorPrimary,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 12.sp),
            ],
            brightness: Brightness.dark,
            // backgroundColor: Colors.red,
            backgroundColor: colorPrimaryBlack,
            elevation: .0,
          ),
          bottomNavigationBar: openbottomsheet
              ? Container()
              : XListView(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ).list(
                  <Widget>[
                    BottomBarContainer(
                      colors: colorPrimaryBlack,
                      icons: Icons.flip,
                      ontap: () {
                        setState(() {
                          flipValue = flipValue == 0 ? math.pi : 0;
                        });
                      },
                      title: 'Flip',
                    ),
                    VerticalDivider(
                      width: .1,
                      thickness: .1,
                      color: Colors.white12,
                    ),
                    BottomBarContainer(
                      colors: colorPrimaryBlack,
                      icons: Icons.rotate_left,
                      ontap: () {
                        setState(() {
                          rotateValue--;
                          isVertical = !isVertical;
                        });
                      },
                      title: 'Left',
                    ),
                    VerticalDivider(
                      width: .1,
                      thickness: .1,
                      color: Colors.white12,
                    ),
                    BottomBarContainer(
                      colors: colorPrimaryBlack,
                      icons: Icons.rotate_right,
                      ontap: () {
                        setState(() {
                          rotateValue++;
                          isVertical = !isVertical;
                        });
                      },
                      title: 'Right',
                    ),
                    VerticalDivider(
                      width: .1,
                      thickness: .1,
                      color: Colors.white12,
                    ),
                    BottomBarContainer(
                      colors: colorPrimaryBlack,
                      icons: Icons.blur_on,
                      ontap: () {
                        showModalBottomSheet(
                          shape: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))
                              .xShapeBorder(),
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setS) {
                                return xColumn.list(
                                  [
                                    'Slider Filter Color'
                                        .toUpperCase()
                                        .xTextColorWhite()
                                        .toCenter(),
                                    Divider(

                                        // height: 1,
                                        ),
                                    20.0.sizedHeight(),
                                    'Slider Color'.xTextColorWhite(),
                                    //   10.0.sizedHeight(),
                                    xRowCC.list([
                                      BarColorPicker(
                                          width: 300,
                                          thumbColor: Colors.white,
                                          cornerRadius: 10,
                                          pickMode: PickMode.Color,
                                          colorListener: (int value) {
                                            setS(() {
                                              setState(() {
                                                colorValue = Color(value);
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setState(() {
                                          setS(() {
                                            colorValue = Colors.transparent;
                                          });
                                        });
                                      })
                                    ]),
                                    5.0.sizedHeight(),
                                    'Slider Blur'.xTextColorWhite(),
                                    10.0.sizedHeight(),
                                    xRow.list([
                                      Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: blurValue,
                                          min: 0.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                blurValue = v;
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setS(() {
                                          setState(() {
                                            blurValue = 0.0;
                                          });
                                        });
                                      })
                                    ]),
                                    5.0.sizedHeight(),
                                    'Slider Opacity'.xTextColorWhite(),
                                    10.0.sizedHeight(),
                                    xRow.list([
                                      Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: opacityValue,
                                          min: 0.00,
                                          max: 1.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                opacityValue = v;
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setS(() {
                                          setState(() {
                                            opacityValue = 0.0;
                                          });
                                        });
                                      })
                                    ]),
                                  ],
                                ).toContainer(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  padding: EdgeInsets.all(20),
                                  height: 400,
                                  color: Colors.black87,
                                );
                              },
                            );
                          },
                        );
                      },
                      title: 'Blur',
                    ),
                    VerticalDivider(
                      width: .1,
                      thickness: .1,
                      color: Colors.white12,
                    ),
                    BottomBarContainer(
                      colors: colorPrimaryBlack,
                      icons: Icons.image_outlined,
                      ontap: () {
                        showModalBottomSheet(
                            shape: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))
                                .xShapeBorder(),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setS) {
                                  return xColumnCC.list([
                                    5.0.sizedHeight(),
                                    'Slider Hue'.xTextColorWhite(),
                                    10.0.sizedHeight(),
                                    xRow.list([
                                      Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: hueValue,
                                          min: -10.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                hueValue = v;
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setS(() {
                                          setState(() {
                                            blurValue = 0.0;
                                          });
                                        });
                                      })
                                    ]),
                                    5.0.sizedHeight(),
                                    'Slider Saturation'.xTextColorWhite(),
                                    10.0.sizedHeight(),
                                    xRow.list([
                                      Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: saturationValue,
                                          min: -10.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                saturationValue = v;
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setS(() {
                                          setState(() {
                                            saturationValue = 0.0;
                                          });
                                        });
                                      })
                                    ]),
                                    5.0.sizedHeight(),
                                    'Slider Brightness'.xTextColorWhite(),
                                    10.0.sizedHeight(),
                                    xRow.list([
                                      Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: brightnessValue,
                                          min: 0.0,
                                          max: 1.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                brightnessValue = v;
                                              });
                                            });
                                          }).xExpanded(),
                                      'Reset'.xTextColorWhite().xFlatButton(
                                          onPressed: () {
                                        setS(() {
                                          setState(() {
                                            brightnessValue = 0.0;
                                          });
                                        });
                                      })
                                    ])
                                  ]);
                                },
                              ).xContainer(
                                  color: Colors.black87,
                                  height: 300,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)));
                            });
                      },
                      title: 'Filter',
                    ),
                  ],
                ).xContainer(
                  padding: EdgeInsets.all(0.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 62.sp,
                )),
    );
  }

  final picker = ImagePicker();

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    var future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return xColumn.list(
          [
            'Select Image Options'.text().xCenter(),
            10.0.sizedHeight(),
            Divider(
              height: 1,
            ),
            xRowCC.list(
              [
                xColumnCC.list(
                  [
                    Icon(Icons.photo_library).xIconButton(),
                    10.0.sizedWidth(),
                    'Open Gallery'.text()
                  ],
                ).xContainer(
                  onTap: () async {
                    var image =
                        await picker.getImage(source: ImageSource.gallery);
                    var decodedImage = await decodeImageFromList(
                        File(image.path).readAsBytesSync());

                    setState(() {
                      height = decodedImage.height;
                      width = decodedImage.width;
                      _image = File(image.path);
                    });
                    setState(() => _controller.clear());
                    Navigator.pop(context);
                  },
                ),
                24.0.sizedWidth(),
                xColumnCC.list(
                  [
                    Icon(Icons.camera_alt).xIconButton(),
                    10.0.sizedWidth(),
                    'Open Camera'.text(),
                  ],
                ).xContainer(onTap: () async {
                  var image = await picker.getImage(source: ImageSource.camera);
                  var decodedImage = await decodeImageFromList(
                      File(image.path).readAsBytesSync());

                  setState(() {
                    height = decodedImage.height;
                    width = decodedImage.width;
                    _image = File(image.path);
                  });
                  setState(() => _controller.clear());
                  Navigator.pop(context);
                })
              ],
            ).xContainer(
              padding: EdgeInsets.all(20),
            )
          ],
        ).xContainer(
          padding: EdgeInsets.all(0.0),
          //   blurRadius: 10.9,
          //shadowColor: Colors.grey[400],
          height: 170,
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return xListView.list(
      [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

Widget imageFilterLatest({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter:
          ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter:
              ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}
