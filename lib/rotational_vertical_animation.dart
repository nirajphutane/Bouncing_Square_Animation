import 'package:flutter/material.dart';

class RVAnimation extends StatefulWidget {

  @override
  _RVAnimationState createState() => _RVAnimationState();
}

class _RVAnimationState extends State<RVAnimation> with SingleTickerProviderStateMixin {

  Animation<double> tween;
  int milliseconds = 2500;
  BorderRadiusGeometry borderRadius;
  int corner = 0;
  bool lock = true, moveUp = true;
  double shadowWidth = 70, squareWidth = 50;

  @override
  void initState() {
    super.initState();
    rotate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 105,
      color: Colors.transparent,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            right: 25,
            bottom: moveUp? 20: 10,
            child: Transform.rotate(
              angle: (3.14/180) * 35,
              child: RotationTransition(
                turns: tween,
                child: AnimatedContainer(
                  width: squareWidth,
                  height: squareWidth,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: borderRadius,
                  ),
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.fastOutSlowIn,
                  child: Icon(Icons.android_sharp, color: Colors.lightGreen,),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 97),
            alignment: Alignment.bottomCenter,
            child: Transform(
              transform: Matrix4(
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0.01,
                0, 0, 0, 1,
              )..rotateX(1),
              child: ClipOval(
                child: AnimatedContainer(
                  height: shadowWidth,
                  width: shadowWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.elliptical(100,50)),
                  ),
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void rotate() {
    AnimationController animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: milliseconds),
    );
    animationController.forward();
    animationController.addListener(() {
      if(animationController.isCompleted){
        animationController.repeat();
      }
    });

    tween = Tween(begin: 0.0, end: 1.0).animate(animationController);
    tween.addListener(() {
      double angle = double.parse(tween.value.toStringAsFixed(4));
      if((angle > 0.20 && angle <0.26 && !lock)||
          (angle > 0.45 && angle <0.51 && !lock)||
          (angle > 0.70 && angle <0.76 && !lock)||
          (angle > 0.95 && angle <0.99 && !lock)){
        lock = true;
        if(mounted){
          setState(() {
            squareWidth = 55;
            shadowWidth = 50;
            moveUp = true;
            borderRadius = BorderRadius.only(
              bottomRight: angle > 0.0 && angle <0.01? Radius.circular(15): Radius.zero,
              topRight: angle > 0.25 && angle <0.26? Radius.circular(15): Radius.zero,
              topLeft: angle > 0.50 && angle <0.51? Radius.circular(15): Radius.zero,
              bottomLeft: angle > 0.75 && angle <0.76? Radius.circular(15): Radius.zero,
            );
          });
        }
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          setState(() {
            squareWidth = 50;
            shadowWidth = 70;
            borderRadius = BorderRadius.circular(0);
            moveUp = false;
          });
        });
      }
      if(angle > 0.15 || angle > 0.30 || angle > 0.55 || angle > 0.80){
        lock = false;
      }
    });
  }
}
