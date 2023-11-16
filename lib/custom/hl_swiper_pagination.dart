import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

/// 自定义页面指示器
class HLSwiperPagination extends SwiperPlugin {
  // 当滚动到此时的颜色
  late Color? activeColor;

  // 默认颜色
  late Color? color;

  // 每个圆点的间距
  final double space;

  // 每个圆点的大小
  final double size;

  // 特殊点的宽度
  final double activeSize;

  final double bottom;

  final AlignmentGeometry? alignment;

  final Key? key;

  HLSwiperPagination(
      {this.color = Colors.grey,
        this.activeColor = Colors.blue,
        this.space = 3.0,
        this.size = 6.0,
        this.activeSize = 20.0,
        this.bottom = 0.0,
        this.alignment = Alignment.center,
        this.key});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    // 处理边界情况
    if (config.itemCount > 20) {
      log(
        'The itemCount is too big, we suggest use FractionPaginationBuilder '
            'instead of DotSwiperPaginationBuilder in this situation',
      );
    }

    int activeIndex = config.activeIndex;
    // 用于存放小圆点
    List<Widget> list = [];
    for (var i = 0; i < config.itemCount; ++i) {
      if (activeIndex == i) {
        list.add(Container(
            key: Key('pagination_$i'),
            margin: EdgeInsets.all(space),
            child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Container(
                color: activeColor,
                width: activeSize,
                height: size,
              ),
            )));
      } else {
        list.add(Container(
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
          child: ClipOval(
            // 圆角组件
            child: Container(
              color: color,
              width: size,
              height: size,
            ),
          ),
        ));
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            left: 15,
            right: 15,
            bottom: bottom,
            child: Container(
              alignment: alignment,
              color: Colors.transparent,
              child: Row(
                key: key,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: list,
              ),
            ))
      ],
    );
  }
}
