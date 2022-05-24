import 'package:flutter/material.dart';
import 'package:flutter_fanfq_draw/drawguess/draw_entity.dart';

import '../draw_provider.dart';

//自定义 Canvas 画板（ pengzhenkun - 2020.04.30 ）
class SignaturePainter extends CustomPainter {
  List<DrawEntity> pointsList;
  late Paint pt;

  SignaturePainter(this.pointsList) {
    pt = Paint() //设置笔的属性
      ..color = pintColor["default"] as Color
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;
  }


  void paint(Canvas canvas, Size size) {

    //绘制效率问题
    // for (int i = 0; i < pointsList.length - 1; i++) {
    //   //画线
    //   //if (pointsList[i] != null && pointsList[i + 1] != null) {
    //   if (pointsList[i].offset.dx != -1 && pointsList[i+1].offset.dx != -1) {
    //     pt
    //       ..color = pintColor[pointsList[i].color]  as Color
    //       ..strokeWidth = pointsList[i].strokeWidth;
    //
    //     canvas.drawLine(pointsList[i].offset, pointsList[i + 1].offset, pt);
    //   }
    // }

    var gpath = Path();


    for (int i = 0; i < pointsList.length - 1; i++) {
      //画线
      if (pointsList[i].offset.dx != -1 && pointsList[i+1].offset.dx != -1) {
        pt
          ..color = pintColor[pointsList[i].color]  as Color
          ..strokeWidth = pointsList[i].strokeWidth;
        var path = Path();

        path.moveTo(pointsList[i].offset.dx, pointsList[i].offset.dy);

        path.lineTo(pointsList[i+ 1].offset.dx, pointsList[i+ 1].offset.dy);



        canvas.drawPath(path, pt);
      }
    }


    //canvas.drawPath(path, pt);

  }

//是否重绘
  bool shouldRepaint(SignaturePainter other) => other.pointsList != pointsList;
}

//drawLine(Offset p1, Offset p2, Paint paint) → void
//canvas.drawOval(
//Rect.fromCircle(center: points[i], radius: 20.0), paint);
//canvas.drawOval(rect, paint)
//canvas.drawCircle(points[i], 10.0, paint);
