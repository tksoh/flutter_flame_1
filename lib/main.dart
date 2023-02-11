import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

// this is main
void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with DoubleTapDetector, TapDetector {
  var girl = SpriteAnimationComponent();
  final cat = SpriteComponent();
  bool running = true;
  String direction = 'down';
  late double xTarget;
  double girlVerticalPos = 0;

  @override
  Future<void>? onLoad() async {
    debugPrint('load assets');

    Flame.device.setPortrait();

    cat.sprite = await loadSprite('cat.png');
    cat
      ..size = Vector2(100, 100)
      ..x = 150
      ..y = 50;
    add(cat);

    var spriteSheet = await images.load('girl_spritesheet.png');
    final spriteSize = Vector2(150, 150);
    final spriteData = SpriteAnimationData.sequenced(
      amount: 10,
      stepTime: 0.03,
      textureSize: Vector2(505.0, 474.0), // size of each frame in spritesheet
    );
    girl = SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
      ..x = 200
      ..y = 200
      ..size = spriteSize;
    xTarget = girl.x;
    add(girl);

    var spriteSheetDeadGirl = await images.load('spritesheet_dead_girl.png');
    final deadGirlSheet = SpriteSheet.fromColumnsAndRows(
      image: spriteSheetDeadGirl,
      columns: 10,
      rows: 1,
    );
    final dead = SpriteComponent(sprite: deadGirlSheet.getSprite(0, 9))
      ..size = Vector2(150, 150)
      ..position = Vector2(300, 300);
    add(dead);

    List<Sprite> sprites =
        await fromJSONAtlas('candy_256.png', 'candy_256_sprites_map.json');

    final candy = SpriteComponent(sprite: sprites[0])
      ..size = Vector2(50, 50)
      ..position = Vector2(200, 300);
    add(candy);

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

    final floor = size[1] - girl.size[1];
    if (girl.y > floor) {
      girl.y = girlVerticalPos * floor;
      direction = 'up';
    }
    if (girl.y < 0) {
      direction = 'down';
    }

    girlVerticalPos = girl.y / floor;
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
      ..x = xPos - cat.size[0] / 2
      ..y = yPos - cat.size[1] / 2;
    super.onTapDown(info);
  }
}
