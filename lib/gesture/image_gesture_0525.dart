import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageGesture extends StatefulWidget {
  const ImageGesture({Key? key}) : super(key: key);

  @override
  _ImageGesture createState() => _ImageGesture();
}

class _ImageGesture extends State<ImageGesture> {
  double _width = 200.0; //通过修改图片宽度来达到缩放效果

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        //指定宽度，高度自适应
        child: Image.asset("./images/preview.jpeg", width: _width),

        //缩放
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            //缩放倍数在0.8到10倍之间
            _width=200*details.scale.clamp(.8, 10.0);
          });
        },

      ),
    );
  }
}