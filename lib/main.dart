import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with DoubleTapDetector {
  final girl = SpriteComponent();
  bool running = true;
  String direction = 'down';

  @override
  Future<void>? onLoad() async {
    debugPrint('load assets');
    girl.sprite = await loadSprite('girl.png');
    girl
      ..size = Vector2(100, 100)
      ..x = 150
      ..y = 50;
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
}
