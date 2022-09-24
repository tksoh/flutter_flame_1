import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with DoubleTapDetector, TapDetector {
  final girl = SpriteComponent();
  bool running = true;
  String direction = 'down';
  late double xTarget;

  @override
  Future<void>? onLoad() async {
    debugPrint('load assets');
    girl.sprite = await loadSprite('girl.png');
    girl
      ..size = Vector2(100, 100)
      ..x = 150
      ..y = 50;
    xTarget = girl.x;
    add(girl);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (direction) {
      case 'down':
        girl.y += 1;
        break;
      case 'up':
        girl.y -= 1;
        break;
    }

    if (girl.x <= xTarget) {
      girl.x += 1;
    } else {
      girl.x -= 1;
    }

    if (girl.y > 400) {
      direction = 'up';
    }
    if (girl.y < 50) {
      direction = 'down';
    }
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }
    running = !running;
    super.onDoubleTap();
  }

  @override
  void onTapDown(TapDownInfo info) {
    debugPrint('onTapDown: ${info.eventPosition.game}');
    final xPos = info.eventPosition.game[0];
    xTarget = xPos;
    super.onTapDown(info);
  }
}
