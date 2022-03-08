import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ScalingAnimation extends StatelessWidget {
  const ScalingAnimation(
      {Key? key,
      required this.child,
      this.duration = 1000,
      this.delay = 0,
      this.control = CustomAnimationControl.playFromStart})
      : super(key: key);

  final Widget child;
  final int duration;
  final int delay;
  final CustomAnimationControl control;

  @override
  Widget build(BuildContext context) {
    return CustomAnimation(
      control: control,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCirc,
      delay: Duration(milliseconds: delay),
      duration: Duration(milliseconds: duration),
      builder: (context, child, double value) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Transform(
              //NOTE ここでx軸に動かす為にTransformを使用している
              transform: Matrix4.diagonal3Values(
                  (1 / value) >= 1.16 ? 1.16 : (1 / value), 1, 1),
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
