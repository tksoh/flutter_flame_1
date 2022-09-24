import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with DoubleTapDetector, TapDetector {
  final girl = SpriteComponent();
  final cat = SpriteComponent();
  bool running = true;
  String direction = 'down';
  late double xTarget;

  @override
  Future<void>? onLoad() async {
    debugPrint('load assets');

    cat.sprite = await loadSprite('cat.png');
    cat
      ..size = Vector2(100, 100)
      ..x = 150
      ..y = 50;
    add(cat);

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

    if (girl.y > size[1] - girl.size[1]) {
      direction = 'up';
    }
    if (girl.y < 0) {
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
    final yPos = info.eventPosition.game[1];
    xTarget = xPos;
    cat
      ..x = xPos
      ..y = yPos;
    super.onTapDown(info);
  }
}
