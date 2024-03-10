import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() => runApp(const SpinIngWheelView());

class SpinIngWheelView extends StatefulWidget {
  const SpinIngWheelView({super.key});

  @override
  State<SpinIngWheelView> createState() => _SpinIngWheelViewState();
}

class _SpinIngWheelViewState extends State<SpinIngWheelView> {
  late MethodChannel _channel;
  final List<(String, Color)> fortuneValues = [
    (
      'Grogu',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Mace Windu',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Obi-Wan Kenobi',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Han Solo',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Luke Skywalker',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Darth Vader',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Yoda',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
    (
      'Ahsoka Tano',
      Color.fromRGBO(
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
        1,
      ),
    ),
  ];
  var alignment = Alignment.topCenter;
  final selected = StreamController<int>();
  int? _selectedIndex;
  var isAnimating = false;

  int roll(int itemCount) {
    return Random().nextInt(itemCount);
  }

  void handleRoll({int? val}) {
    final nVal = roll(fortuneValues.length);
    selected.add(val ?? nVal);
  }

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('SpinIngWheelChannel');
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "Spin":
          final val = call.arguments as int;
          handleRoll(val: val);
          break;
        default:
          break;
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: RepaintBoundary(
              child: FortuneWheel(
                animateFirst: false,
                alignment: alignment,
                selected: selected.stream,
                onAnimationStart: () {
                  _channel.invokeMethod("isAnimating", true);
                },
                onAnimationEnd: () {
                  _channel.invokeMethod("isAnimating", false);
                  _channel.invokeMethod(
                    "SpinResult",
                    fortuneValues[_selectedIndex ?? 0].$1,
                  );
                },
                onFocusItemChanged: (e) {
                  _selectedIndex = e;
                },
                onFling: handleRoll,
                hapticImpact: HapticImpact.heavy,
                indicators: [
                  FortuneIndicator(
                    alignment: alignment,
                    child: const TriangleIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
                physics: NoPanPhysics(),
                items: fortuneValues
                    .map(
                      (e) => FortuneItem(
                        child: Container(
                          color: e.$2,
                          alignment: Alignment.center,
                          child: Text(
                            e.$1,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
