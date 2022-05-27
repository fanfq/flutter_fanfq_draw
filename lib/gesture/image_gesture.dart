import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/ui_image.dart';

class ImageGesture extends StatefulWidget {
  const ImageGesture({Key? key}) : super(key: key);

  @override
  _ImageGesture createState() => _ImageGesture();
}

class _ImageGesture extends State {

  //String backgroundUrl = "https://cdn.fanfq.com/picgo/20220524222322.jpeg";
  String backgroundUrl = "https://img1.maka.im/materialStore/beijingshejia/tupianbeijinga/9/M_69F3SAO8/M_69F3SAO8_v1.jpg";

  GlobalKey _contentGlobalKey = GlobalKey();

  ///图片的唯一KEY
  GlobalKey _pictureGlobalKey = GlobalKey();

  double viewWidth = 125;//裁切宽度
  double viewHeight = 196;//裁切高度

  double imageOriginWidth = 750;
  double imageOriginHeight = 1181;

  double _currentScale = 1.0;//缩放比例
  Offset _pictureDefOffset = Offset(100, 200);//左上角
  Offset _dragViewOffset = Offset(100, 200);//左上角

  double _lastViewScale = 1.0;
  late Offset _lastViewPoint;

  double whRate = 1/2;//长宽比例
  double angle = 0;//角度

  String cropInfo ="0,0,0,0";//裁切

  late ui.Image img;

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentScale = 0.82;
  }

  initData() async{
    img = await UiImageUtils.loadImage("images/preview.jpeg");
  }

  @override
  void initState() {
    super.initState();
    print('initState');

    initData();

    // RenderBox? referenceBox = _contentGlobalKey.currentContext?.findRenderObject() as RenderBox;
    // print('${referenceBox.size}');
    // _pictureDefOffset = Offset(referenceBox.size.width / 2 - viewWidth/2, referenceBox.size.height / 2 - viewHeight/2);//左上角
    // _dragViewOffset = Offset(referenceBox.size.width / 2 - viewWidth/2, referenceBox.size.height / 2 - viewHeight/2);//左上角
  }



  @override
  Widget build(BuildContext context){

    print('build');


    return Scaffold(
        appBar: AppBar(
          title: Text("Picture Crop"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.crop),
              onPressed: () {
                //print("object");
                saveClipperInfo();
              },
            ),
          ],
        ),

        body:GestureDetector(
          key: _contentGlobalKey,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: (d) => _handleScaleUpdate(context.size!, d),
          onScaleEnd: _handleScaleEnd,

          child: Stack(
            children: [
            ///辅助线


            ///图片
            // Positioned(
            //   left: _dragViewOffset.dx,
            //   top: _dragViewOffset.dy,
            //   // child: Transform.rotate(
            //   //   angle: angle,//角度
            //     child: Image.asset(
            //       'images/preview.jpeg',
            //       key: _pictureGlobalKey,
            //       width: viewWidth,
            //       height: viewHeight,
            //       fit: BoxFit.cover,
            //     ),
            //   // ),
            // ),
            ///
          CustomPaint(
            painter: DrawImage(img,Size(viewWidth, viewHeight), _pictureDefOffset,_currentScale),
            size: Size(double.infinity, double.infinity),
          ),



            ///自定义画板
            CustomPaint(
              painter: DrawRectLight(Size(viewWidth, viewHeight), _pictureDefOffset),
              size: Size(double.infinity, double.infinity),
            ),

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,

              child: Center(
                child: Text('${cropInfo}'),
              ),

              // child: InkWell(
              //   onTap: saveClipperInfo,
              //   child: Text(
              //     "双指缩放调整图片大小",
              //     style: TextStyle(fontSize: 14, color: Colors.white),
              //     textAlign: TextAlign.center,
              //   ),
              // ),

            ),


          ],
        ),
      ),


    );
  }

  // Offset _getRelativePosition() {
  //   RenderBox imageRenderBox = _pictureGlobalKey.currentContext?.findRenderObject() as RenderBox ;
  //   RenderBox contentRenderBox = _contentGlobalKey.currentContext?.findRenderObject() as RenderBox ;
  //   Offset _relativePosition = imageRenderBox.globalToLocal(
  //     _pictureDefOffset,
  //     ancestor: contentRenderBox,
  //   );
  //   return _relativePosition;
  // }

  void _handleScaleStart(ScaleStartDetails details) {
    print('_handleScaleStart');
    _lastViewScale = _currentScale;
    _lastViewPoint = details.focalPoint;
  }

  void _handleScaleUpdate(Size size, ScaleUpdateDetails details) {
    ///print("_handleScaleUpdate");
    if (details.scale != 1) {
      ///缩放
      double tempScale = _lastViewScale * details.scale;

      //缩放可以保证不小于1, 放大到多大并不管
      if (tempScale < 1) return;
      //缩放生效
      _currentScale = tempScale;
    } else {
      Offset tempPositionPoint = _dragViewOffset + (details.focalPoint - _lastViewPoint);
      _dragViewOffset = tempPositionPoint;
      _lastViewPoint = details.focalPoint;
    }


    ///角度
    if(details.rotation !=0){
      angle = details.rotation;
      print('angle:${angle}');
    }


    // double w = size.width - 40;
    // double pRate = viewWidth / viewHeight;
    // double h = size.height * pRate;


    ///检测是否临界边界
    double _correctDx = _dragViewOffset.dx;
    double _correctDy = _dragViewOffset.dy;

    double leftVerticalLine = (viewWidth * _currentScale - viewWidth) / 2 + _pictureDefOffset.dx;
    double topVerticalLine = (viewHeight * _currentScale - viewHeight) / 2 + _pictureDefOffset.dy;
    double rightVerticalLine = _pictureDefOffset.dx - (leftVerticalLine - _pictureDefOffset.dx);
    double bottomHorizontalLine = _pictureDefOffset.dy - (topVerticalLine - _pictureDefOffset.dy);

    if (_correctDx > leftVerticalLine) {
      _correctDx = leftVerticalLine;
    }
    if (_correctDy > topVerticalLine) {
      _correctDy = topVerticalLine;
    }
    if (_correctDx < rightVerticalLine) {
      _correctDx = rightVerticalLine;
    }
    if(_correctDy < bottomHorizontalLine){
      _correctDy = bottomHorizontalLine;
    }

    _dragViewOffset = Offset(_correctDx, _correctDy);


    setState(() {});
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    setState(() {});

    saveClipperInfo();
  }

  void saveClipperInfo() {
    int clipWidth = (imageOriginWidth / _currentScale).round();
    int clipHeight = (imageOriginHeight / _currentScale).round();

    int offsetX = ((((viewWidth * _currentScale - viewWidth) / 2 + _pictureDefOffset.dx) - _dragViewOffset.dx) *
        (imageOriginWidth / (viewWidth * _currentScale)))
        .abs()
        .round();
    int offsetY = ((((viewHeight * _currentScale - viewHeight) / 2 + _pictureDefOffset.dy) - _dragViewOffset.dy) *
        (imageOriginHeight / (viewHeight * _currentScale)))
        .abs()
        .round();

    setState(() {
      cropInfo = "x_$offsetX,"
          "y_$offsetY,"
          "w_$clipWidth,"
          "h_$clipHeight";
    });

    print(backgroundUrl +
        "?x-oss-process=image/crop,"
            "x_$offsetX,"
            "y_$offsetY,"
            "w_$clipWidth,"
            "h_$clipHeight");
  }
}

class DrawImage extends CustomPainter{

  ui.Image _uiImg;//图片
  Size _pictureSize; //裁切尺寸
  Offset _pictureOffset;
  double _scale;

  DrawImage(this._uiImg,this._pictureSize, this._pictureOffset,this._scale);


  @override
  void paint(Canvas canvas,Size size){

    //图片实际尺寸
    Size imgSize = Size( _uiImg.width.toDouble(),_uiImg.height.toDouble());

    //缩放后的目标尺寸
    Rect dstRect = Rect.fromLTWH(0, 0, imgSize.width*_scale,imgSize.height*_scale );

    // 根据适配模式，计算适合的缩放尺寸
    FittedSizes fittedSizes = applyBoxFit(
        BoxFit.cover, imgSize, dstRect.size);

    // 获得一个图片区域中，指定大小的，居中位置处的 Rect
    Rect inputRect = Alignment.center.inscribe(
        fittedSizes.source, Offset.zero & imgSize);

    // 获得一个绘制区域内，指定大小的，居中位置处的 Rect
    Rect outputRect = Alignment.center.inscribe(
        fittedSizes.destination, dstRect);



    canvas.drawImageRect(_uiImg, inputRect, outputRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class DrawRectLight extends CustomPainter {
  Size _pictureSize; //裁切尺寸
  Offset _pictureOffset;

  DrawRectLight(this._pictureSize, this._pictureOffset);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint
      ..style = PaintingStyle.fill
      ..color = Color(0xaa000000);


    // print('_pictureOffset:${_pictureOffset},_pictureSize:${_pictureSize}');
    // print('size.width:${size.width},size.height:${size.height}');
    // var centerX = size.width/2;//屏幕中心
    // var centerY = size.height/2;//屏幕中心
    // double w = size.width - 40;
    // double pRate = _pictureSize.width / _pictureSize.height;
    // double h = size.height * pRate;
    // print('wp:${pRate},w:${w},h:${h}');

    ///裁切蒙版 假设是中心点
    canvas.clipRect(
      Rect.fromLTRB(
        _pictureOffset.dx,
        _pictureOffset.dy,
        _pictureOffset.dx + _pictureSize.width,
        _pictureOffset.dy + _pictureSize.height,

        // centerX - w/2,
        // centerY - h/2,
        // w,
        // h,
      ),
      clipOp: ui.ClipOp.difference,
    );


    ///裁切蒙版背景
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    ///辅助线
    // canvas.drawRect(Rect.fromLTRB(
    //   _pictureOffset.dx,
    //   _pictureOffset.dy,
    //   _pictureOffset.dx + _pictureSize.width,
    //   _pictureOffset.dy + _pictureSize.height,), paintW);
    // canvas.drawLine(
    //     Offset(_pictureOffset.dx-20, _pictureOffset.dy),
    //     Offset(_pictureOffset.dx-20 + _pictureSize.width, _pictureOffset.dy + _pictureSize.height),
    //     Paint()..color=Colors.redAccent..style = PaintingStyle.stroke..strokeWidth=5.0);
    // // print('${_pictureOffset.dx},${_pictureOffset.dy},${_pictureOffset.dx + _pictureSize.width},${_pictureOffset.dy + _pictureSize.height},');
    // canvas.drawRect(
    //     Rect.fromLTRB(_pictureOffset.dx, _pictureOffset.dy, _pictureOffset.dx + _pictureSize.width, _pictureOffset.dy + _pictureSize.height),
    //     Paint()..color=Colors.redAccent..style = PaintingStyle.stroke..strokeWidth=5.0
    // );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}