import 'dart:math';

import 'package:flutter/material.dart';

class HLPopupWindow extends StatefulWidget {
  /// 弹窗方法封装
  ///
  ///  * context  上下文
  ///  * targetKey  目标视图的key，必须使用GlobalKey
  ///  * popSize 弹出视图大小
  ///  * popDirection  弹出弹窗方向，默认在目标视图下方
  ///  * popWidget  弹出视图
  ///  * offset  弹出视图偏移量，大于0，往右、往上，默认0 居中形式弹出
  ///  * hasArrow 是否需要箭头，默认有的
  ///  * arrowHeight 箭头高度，默认8
  ///  * arrowWidth 箭头宽度，默认8
  ///  * corner 圆角半径，默认12
  ///  * duration 弹出时间，默认180，单位ms
  ///  * backColor 弹窗蒙版背景色，默认Color.fromRGBO(0, 0, 0, 0.35)
  static void showPopWindow(
    context, {
    required GlobalKey targetKey,
    required Size popSize,
    PopDirection popDirection = PopDirection.bottom,
    required Widget popWidget,
    Offset offset = Offset.zero,
    bool hasArrow = true,
    double arrowHeight = 8,
    double arrowWidth = 8,
    double corner = 8,
    int duration = 180,
    Color backColor = const Color.fromRGBO(0, 0, 0, 0.35),
  }) {
    Navigator.push(
        context,
        PopRoute(
            child: HLPopupWindow(
          targetKey: targetKey,
          popSize: popSize,
          popDirection: popDirection,
          popWidget: popWidget,
          offset: offset,
          hasArrow: hasArrow,
          arrowHeight: arrowHeight,
          arrowWidth: arrowWidth,
          corner: corner,
          duration: duration,
          backColor: backColor,
        )));
  }

  GlobalKey targetKey;
  Size popSize;
  PopDirection popDirection;
  Widget popWidget;
  Offset offset;
  bool hasArrow;
  double arrowHeight;
  double arrowWidth;
  double corner;
  int duration;
  Color backColor;

  HLPopupWindow({
    super.key,
    required this.popWidget,
    required this.targetKey,
    required this.popSize,
    required this.popDirection,
    required this.offset,
    required this.hasArrow,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.corner,
    required this.duration,
    required this.backColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _HLPopupWindowState();
  }
}

class _HLPopupWindowState extends State<HLPopupWindow> {
  double left = -100;
  double top = -100;
  Offset scaleOrigin = Offset.zero; // 缩放锚点
  late AnimationController animateController;

  @override
  void initState() {
    super.initState();
    // 监听渲染完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox? renderBox =
          widget.targetKey.currentContext?.findRenderObject() as RenderBox?;
      Offset localToGlobal = renderBox != null
          ? renderBox!.localToGlobal(Offset.zero)
          : const Offset(0, 0); //targetWidget的坐标位置，左上角的点
      Size targetSize = renderBox != null
          ? renderBox!.size
          : const Size(0, 0); //targetWidget的size

      switch (widget.popDirection) {
        case PopDirection.left:
          left = localToGlobal.dx - widget.popSize.width + widget.offset.dx;
          top = localToGlobal.dy +
              targetSize.height / 2 -
              widget.popSize.height / 2;
          break;
        case PopDirection.top:
          left = localToGlobal.dx +
              targetSize.width / 2 -
              widget.popSize.width / 2;
          top = localToGlobal.dy - widget.popSize.height + widget.offset.dy;
          fixPosition(widget.popSize);
          break;
        case PopDirection.right:
          left = localToGlobal.dx + targetSize.width + widget.offset.dx;
          top = localToGlobal.dy +
              targetSize.height / 2 -
              widget.popSize.height / 2;
          break;
        case PopDirection.bottom:
          // 这边如果弹窗超出屏幕了会自动缩进来，与屏幕边缘对齐，具体位置需要设置offset自行调节
          left = localToGlobal.dx +
              targetSize.width / 2 -
              widget.popSize.width / 2 +
              widget.offset.dx;
          top = localToGlobal.dy + targetSize.height + widget.offset.dy;
          fixPosition(widget.popSize);
          break;
      }
      // 缩放的默认位置为弹窗的中心点，此处设置右上角弹出
      scaleOrigin =
          Offset(widget.popSize.width / 2, -widget.popSize.height / 2);
      setState(() {});
    });
  }

  @override
  void dispose() async {
    print("popwindow dispose");
    super.dispose();
  }

  void fixPosition(Size buttonSize) {
    if (left < 0) {
      left = 0;
    }
    if (left + buttonSize.width >= MediaQuery.of(context).size.width) {
      left = MediaQuery.of(context).size.width - buttonSize.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: widget.backColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Positioned(
            left: left,
            top: top,
            // child: GestureDetector(
            //   child: widget.popWidget == null
            //       ? _buildWidget(widget.msg)
            //       : _buildCustomWidget(widget.popWidget),
            // ),
            // 缩放动画
            child: ZoomInOffset(
              duration: Duration(milliseconds: widget.duration),
              offset: scaleOrigin,
              controller: (controller) {
                animateController = controller;
                // widget.fun(closeModel);
              },
              // 通过Stack在底层放一层涂层，绘制箭头背景
              child: Stack(
                children: [
                  Container(
                    width: widget.popSize.width,
                    // 箭头背景高度要比弹窗的高度多一个arrowHeight，此处要判断是否有箭头
                    height: widget.popSize.height +
                        (widget.hasArrow ? widget.arrowHeight : 0),
                    child: CustomPaint(
                      size: Size(
                          widget.popSize.width,
                          widget.popSize.height +
                              (widget.hasArrow ? widget.arrowHeight : 0)),
                      painter: ArrowPainter(
                          widget.popDirection,
                          Size(
                              widget.popSize.width,
                              widget.popSize.height +
                                  (widget.hasArrow ? widget.arrowHeight : 0)),
                          arrowWidth: widget.arrowWidth,
                          arrowHeight: widget.arrowHeight,
                          corner: widget.corner,
                          arrowOffset: widget.offset),
                    ),
                  ),
                  // 弹出窗
                  Container(
                    // HLViewTool.createDecoration(
                    //     borderColor: Colors.white,
                    //     contentColor: Colors.white,
                    //     radius: 6,
                    //     enableShadow: true),
                    margin: EdgeInsets.fromLTRB(
                        0, (widget.hasArrow ? widget.arrowHeight : 0), 0, 0),
                    child: widget.popWidget,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWidget(String text) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Text(text),
      );

  Widget _buildCustomWidget(Widget child) => Container(
        child: child,
      );
}

/// 绘制弹窗背景
class ArrowPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.white // 画笔颜色
    ..strokeCap = StrokeCap.round // 画笔笔触类型
    ..strokeJoin = StrokeJoin.round // 画笔转角类型
    ..isAntiAlias = true // 是否启动抗锯齿
    ..style = PaintingStyle.fill // 绘画风格，默认为填充
    ..strokeWidth = 2; // 画笔宽度
  // 弹窗方向
  late PopDirection popDirection;

  // 弹窗大小
  late Size popSize;

  // 箭头宽度
  late double arrowWidth;

  // 箭头高度
  late double arrowHeight;

  // 圆角半径
  late double corner;

  // 偏移量，箭头位置默认应该是中间，需要根据pop时的offset，反向计算
  late Offset arrowOffset;

  ArrowPainter(this.popDirection, this.popSize,
      {required this.arrowWidth,
      required this.arrowHeight,
      required this.corner,
      required this.arrowOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    switch (popDirection) {
      case PopDirection.left:
        break;
      case PopDirection.top:
        break;
      case PopDirection.right:
        break;
      case PopDirection.bottom:
        var arrowDx = popSize.width / 2 - arrowOffset.dx;
        // 顶部
        path.moveTo(corner, arrowHeight);
        // 箭头
        path.lineTo(arrowDx - arrowWidth / 2, arrowHeight);
        path.lineTo(arrowDx, 0);
        path.lineTo(arrowDx + arrowWidth / 2, arrowHeight);
        path.lineTo(popSize.width - corner, arrowHeight);
        // 右上角
        path.addArc(
          Rect.fromCenter(
              center: Offset(popSize.width - corner, arrowHeight + corner),
              width: corner * 2,
              height: corner * 2),
          -0.5 * pi, // 起始位置，默认是3点钟方向
          0.5 * pi, // 弧度，pi是180度
        );
        // 右侧
        path.lineTo(popSize.width, popSize.height - corner);
        // 右下角
        path.addArc(
          Rect.fromCenter(
              center: Offset(popSize.width - corner, popSize.height - corner),
              width: corner * 2,
              height: corner * 2),
          0,
          0.5 * pi,
        );
        // 底部
        path.lineTo(corner, popSize.height);
        // 左下角
        path.addArc(
          Rect.fromCenter(
              center: Offset(corner, popSize.height - corner),
              width: corner * 2,
              height: corner * 2),
          0.5 * pi,
          0.5 * pi,
        );
        // 左侧
        path.lineTo(0, arrowHeight + corner);
        // 左上角
        path.addArc(
          Rect.fromCenter(
              center: Offset(corner, arrowHeight + corner),
              width: corner * 2,
              height: corner * 2),
          pi,
          0.5 * pi,
        );
        // 只画不规则边框的线(四个圆角+箭头)，无法全部填充满，只能多加几条线
        path.lineTo(popSize.width - corner, arrowHeight);
        path.lineTo(popSize.width, popSize.height - corner);
        path.lineTo(corner, popSize.height);
        path.close();
        canvas.drawPath(path, _paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// 继承并重写PopupRoute
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 200);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

/// popWindow的方向
enum PopDirection { left, top, right, bottom }

/// 弹窗缩放动画
class ZoomInOffset extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  // 把控制器通过函数传递出去，可以在父组件进行控制
  final Function(AnimationController) controller;
  final bool manualTrigger;
  final bool animate;
  final double from;

  // 缩放锚点
  final Offset offset;

  ZoomInOffset(
      {Key? key,
      required this.child,
      required this.duration,
      this.delay = const Duration(milliseconds: 0),
      required this.controller,
      this.manualTrigger = false,
      this.animate = true,
      required this.offset,
      this.from = 1.0})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _ZoomInState createState() => _ZoomInState();
}

class _ZoomInState extends State<ZoomInOffset>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool disposed = false;
  late Animation<double> fade;
  late Animation<double> opacity;

  @override
  void dispose() async {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    // 缩放比例
    fade = Tween(begin: 0.0, end: widget.from)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: controller));

    // 不透明度
    opacity = Tween<double>(begin: 0.0, end: 1).animate(controller);

    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller!.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller!.forward();
    //   }
    // });

    if (!widget.manualTrigger && widget.animate) {
      Future.delayed(widget.delay, () {
        if (!disposed) {
          controller?.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
      animation: fade,
      builder: (BuildContext context, Widget? child) {
        // 这个transform有origin的可选构造参数，我们可以手动添加
        return Transform.scale(
          origin: widget.offset,// 缩放锚点
          scale: fade.value,// 缩放比例
          child: Opacity(
            opacity: opacity.value,// 动画透明度
            child: widget.child,
          ),
        );
      },
    );
  }
}
