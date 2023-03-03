import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  const SkeletonContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.borderRadius});

  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    Key? key,
  }) : super(key: key);

  // ignore: use_key_in_widget_constructors
  const SkeletonContainer.square(
      {required double width,
      required double height,
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12))})
      : this._(width: width, height: height, borderRadius: borderRadius);

  // ignore: use_key_in_widget_constructors
  const SkeletonContainer.circular(
      {required double width,
      required double height,
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(90))})
      : this._(width: width, height: height, borderRadius: borderRadius);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: width,
        height: height,
        decoration:
            BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius),
      ),
    );
  }
}
