import 'dart:math';
import 'package:flutter/material.dart';

int numItems = 10;
var onSelectCard = ValueNotifier<int>(0);

class RotationSceneV2 extends StatefulWidget {
  const RotationSceneV2({
    super.key,
    // this.isVertical = false
  });
  // final bool isVertical;

  @override
  _RotationSceneV2State createState() => _RotationSceneV2State();
}

class _RotationSceneV2State extends State<RotationSceneV2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'carrousel',
      //     style: TextStyle(fontSize: 13),
      //   ),
      //   centerTitle: false,
      //   elevation: 2,
      //   backgroundColor: Colors.transparent,
      // ),
      bottomNavigationBar: const SceneCardSelector(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xAA74ABE4), Color(0xAAA892ED)],
          stops: [0, 1],
        )),
        child: const MyScener(),
      ),
    );
  }
}

class CardData {
  late Color color;
  late double x, y, z, angle;
  final int idx;
  double alpha = 0;

  Color get lightColor {
    var val = HSVColor.fromColor(color);
    return val.withSaturation(.5).withValue(.8).toColor();
  }

  CardData(this.idx) {
    color = Colors.primaries[idx % Colors.primaries.length];
    x = 0;
    y = 0;
    z = 0;
  }
}

class MyScener extends StatefulWidget {
  const MyScener({super.key});

  @override
  _MyScenerState createState() => _MyScenerState();
}

class _MyScenerState extends State<MyScener> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  List<CardData> cardData = [];
  double radio = 200.0;
  double radioStep = 0;
  bool isMousePressed = false;
  double _dragX = 0;
  double selectedAngle = 0;

  @override
  void initState() {
    cardData = List.generate(numItems, (index) => CardData(index)).toList();
    radioStep = (pi * 2) / numItems;

    _scaleController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _scaleController.addListener(() => setState(() {}));

    onSelectCard.addListener(() {
      var idx = onSelectCard.value;
      _dragX = 0;
      selectedAngle = -idx * radioStep;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var initAngleOffset = pi / 2 + (-_dragX * .006);
    initAngleOffset += selectedAngle;

    // process positions.
    for (var i = 0; i < cardData.length; ++i) {
      var c = cardData[i];
      double ang = initAngleOffset + c.idx * radioStep;
      c.angle = ang + pi / 2;
      /// horizontal
      c.x = cos(ang) * radio;
     // c.y = sin(ang) * 10;
      c.z = sin(ang) * radio;
    }

    // sort in Z axis.
    cardData.sort((a, b) => a.z.compareTo(b.z));

    var list = cardData.map((vo) {
      var c = addCard(vo);
      var mt2 = Matrix4.identity();
      mt2.setEntry(3, 2, 0.001);
      mt2.translate(vo.x, vo.y, -vo.z);
      mt2.rotateY(vo.angle + pi);
      c = Transform(
        alignment: Alignment.center,
        origin: Offset(0.0, -100 - _scaleController.value * 200.0),
        transform: mt2,
        child: c,
      );

      // depth of field... doesnt work on web.
//      var blur = .4 + ((1 - vo.z / radio) / 2) * 2;
//      c = BackdropFilter(
//        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//        child: c,
//      );

      return c;
    }).toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (e) {
        isMousePressed = true;
        setState(() {});
        _scaleController.animateTo(1,
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn);
      },
      onPanUpdate: (e) {
        _dragX += e.delta.dx;
        setState(() {});
      },
      onPanEnd: (e) {
        isMousePressed = false;
        _scaleController.animateTo(0,
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn);
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: list,
        ),
      ),
    );
  }

  Widget addCard(CardData vo) {
    var alpha = ((1 - vo.z / radio) / 2) * .6;
    Widget c;
    c = Container(
      margin: const EdgeInsets.all(12),
      width: 120,
      height: 80,
      alignment: Alignment.center,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(alpha),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, .9],
          colors: [vo.lightColor, vo.color],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2 + alpha * .2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 2))
        ],
      ),
      child: Text('ITEM ${vo.idx}'),
    );
    return c;
  }
}

class SceneCardSelector extends StatelessWidget {
  const SceneCardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 80,
      child: Row(
        children: List.generate(
            numItems,
            (index) => Expanded(
                  child: SizedBox(
                    height: 80,
                    child: OutlinedButton(
                      child: Text(index.toString()),
                      onPressed: () => onSelectCard.value = index,
                    ),
                  ),
                )),
      ),
    );
  }
}
