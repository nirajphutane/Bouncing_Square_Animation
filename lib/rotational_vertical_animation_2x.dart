import 'package:flutter/material.dart';

class RVAnimation extends StatefulWidget {

  @override
  _RVAnimationState createState() => _RVAnimationState();
}

class _RVAnimationState extends State<RVAnimation> with SingleTickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> tween;
  BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomRight: Radius.circular(5),
  );
  bool lock = false, moveUp = true;
  double shadowWidth = 150, squareWidth = 100;
  final int milliseconds = 2000;

  @override
  void initState() {
    super.initState();
    rotate();
  }

  @override
  void dispose() {
    animationController.dispose();
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
            bottom: moveUp? 40: 8,
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
    animationController = AnimationController(
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
      if(angle >= 0.20 && angle <= 0.22){
        verticalBounce(BorderRadius.only(topRight: Radius.circular(50)));
      } else if(angle >= 0.45 && angle <= 0.47){
        verticalBounce(BorderRadius.only(topLeft: Radius.circular(50)));
      } else if(angle >= 0.70 && angle <= 0.72){
        verticalBounce(BorderRadius.only(bottomLeft: Radius.circular(50)));
      } else if(angle >= 0.97 && angle <= 0.99){
        verticalBounce(BorderRadius.only(bottomRight: Radius.circular(50)));
      }
    });
  }

  void verticalBounce(BorderRadiusGeometry borderRadiusGeometry){
    setState(() {
      squareWidth = 110;
      shadowWidth = 120;
      moveUp = false;
    });
    Future.delayed(Duration(milliseconds: 10)).then((value) {
      setState(() {
        borderRadius = borderRadiusGeometry;
      });
    });
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        squareWidth = 100;
        shadowWidth = 150;
        borderRadius = BorderRadius.circular(5);
        moveUp = true;
      });
    });
  }
}
