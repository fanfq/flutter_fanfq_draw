
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class UiImageUtils{

  ///本地图片转换成Uint8List的方法
  ///ui.Image uiBg = await ImageUtils.loadImage("images/pngbg512.png");
  static Future<ui.Image> loadImage(String asset) async{
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  ///Uint8List -> ui.Image
  static Future<ui.Image> loadImageByUint8List(Uint8List data) async{
    ui.Codec codec = await ui.instantiateImageCodec(data);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  ///ui.Image -> Uint8List
  static Future<Uint8List> transferUiImageToUint8List(ui.Image uiImg) async{
    ByteData? pngActorBytes = await uiImg.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngSaveBytes = pngActorBytes!.buffer.asUint8List();
    return pngSaveBytes;
  }

  ///ui.Image uiBg = await ImageUtils.loadImageByProvider(AssetImage("images/pngbg512.png"));
  static Future<ui.Image> loadImageByProvider(ImageProvider provider, {ImageConfiguration config = ImageConfiguration.empty}) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    late ImageStreamListener listener;
    ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }


}