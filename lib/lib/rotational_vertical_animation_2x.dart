import 'package:flutter/material.dart';

class RVAnimation extends StatefulWidget {

  @override
  _RVAnimationState createState() => _RVAnimationState();
}

class _RVAnimationState extends State<RVAnimation> with SingleTickerProviderStateMixin {

  Animation<double> tween;
  int milliseconds = 2500;
  BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomRight: Radius.circular(5),
  );
  bool lock = false, moveUp = true;
  double shadowWidth = 150, squareWidth = 100;

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
      width: 200,
      height: 210,
      color: Colors.transparent,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            right: 50,
            bottom: moveUp? 40: 10,
            child: Transform.rotate(
              angle: (3.14/180) * 45,
              child: RotationTransition(
                turns: tween,
                child: AnimatedContainer(
                  width: squareWidth,
                  height: squareWidth,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: borderRadius,
                  ),
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.fastOutSlowIn,
                  // child: Icon(Icons.android_sharp, color: Colors.lightGreen,),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
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
                    borderRadius: BorderRadius.all(Radius.elliptical(200,100)),
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
      if((angle > 0.25 && angle < 0.29 && !lock)||
        (angle > 0.50 && angle < 0.54 && !lock)||
        (angle > 0.75 && angle < 0.79 && !lock)||
        (angle > 0.95 && angle < 0.99 && !lock)){
        lock = true;
        if(mounted){
          setState(() {
            squareWidth = 110;
            shadowWidth = 120;
            moveUp = false;
            borderRadius = BorderRadius.only(
              topRight: angle > 0.27 && angle < 0.29? Radius.circular(50): Radius.circular(5),
              topLeft: angle > 0.52 && angle < 0.54? Radius.circular(50): Radius.circular(5),
              bottomLeft: angle > 0.77 && angle < 0.79? Radius.circular(50): Radius.circular(5),
              bottomRight: angle > 0.97 && angle < 0.99? Radius.circular(50): Radius.circular(5),
            );
          });
        }
        Future.delayed(Duration(milliseconds: 300)).then((value) {
          setState(() {
            squareWidth = 100;
            shadowWidth = 150;
            borderRadius = BorderRadius.circular(5);
            moveUp = true;
          });
        });
      }
      lock = false;
    });
  }
}
