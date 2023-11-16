import 'package:flutter/material.dart';
import 'package:hlflutter/common/hl_util.dart';

class HLIndicator extends StatelessWidget {
  HLIndicator({super.key,
    this.currentPage = 0,
    this.itemCount = 0,
  });

  // PageView的控制器
  final int currentPage;

  // 指示器的个数
  final int itemCount;

  // 普通的颜色
  final Color normalColor = Util.rgbColor('#B9B9B9');

  // 选中的颜色
  final Color selectedColor = Util.rgbColor('#5F5EFF');

  // 点的大小
  final double size = Util.px(6);

  // 点的间距
  final double spacing = Util.px(5);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, spacing);
      }),
    );
  }

  // 点的Widget
  Widget _buildIndicator(
      int index, int pageCount, double dotSize, double spacing) {
    // 是否是当前页面被选中
    bool isCurrentPageSelected =
        index == (currentPage >= 0 ? currentPage.round() % pageCount : 0);

    return SizedBox(
      height: size,
      width: size + (2 * spacing),
      child: Center(
        child: Material(
          color: isCurrentPageSelected ? selectedColor : normalColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize,
            height: dotSize,
          ),
        ),
      ),
    );
  }

}
