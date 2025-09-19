import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import '../controllers/player_controller.dart';

class PlayerSpriteSheetComponentAnimationFull extends SpriteAnimationComponent 
    with HasGameReference, KeyboardHandler, TapCallbacks {
  
  final DinoController controller = DinoController();
  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation deadAnimation;

  final double walkSpeed = 200.0;
  bool isMovingRight = true;

  @override
  Future<void> onLoad() async {
    final spriteImage = await Flame.images.load('dino_full.png');
    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(680, 472),
    );

    // Inisialisasi animasi
    idleAnimation = _createAnimation(spriteSheet, 1, 2, 10, 5, 0.08);
    walkAnimation = _createAnimation(spriteSheet, 6, 2, 10, 5, 0.08);
    runAnimation = _createAnimation(spriteSheet, 5, 0, 8, 5, 0.08);
    jumpAnimation = _createAnimation(spriteSheet, 3, 0, 12, 5, 0.08);
    deadAnimation = _createAnimation(spriteSheet, 0, 0, 8, 5, 0.08);
    
    // Set animasi awal
    animation = idleAnimation;
    
    // Set ukuran dan posisi
    size = Vector2(680 * 0.3, 472 * 0.3);
    position = Vector2(
      (game.size.x / 2) - (size.x / 2),
      (game.size.y / 2) - (size.y / 2)
    );

    // Setup controller callback
    controller.onStateChanged = _updateAnimation;
  }

  SpriteAnimation _createAnimation(SpriteSheet sheet, int xInit, int yInit, 
      int step, int sizeX, double stepTime) {
    
    final List<Sprite> spriteList = [];
    int x = xInit;
    int y = yInit - 1;
    
    for (var i = 0; i < step; i++) {
      if (y >= sizeX) {
        y = 0;
        x++;
      } else {
        y++;
      }
      spriteList.add(sheet.getSprite(x, y));
    }
    
    return SpriteAnimation.spriteList(spriteList, stepTime: stepTime, loop: true);
  }

  void _updateAnimation() {
    switch (controller.currentState) {
      case DinoState.idle:
        animation = idleAnimation;
        break;
      case DinoState.walking:
        animation = walkAnimation;
        break;
      case DinoState.running:
        animation = runAnimation;
        break;
      case DinoState.jumping:
        animation = jumpAnimation;
        break;
      case DinoState.dead:
        animation = deadAnimation;
        break;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Hanya merespon jika sedang idle atau walking
    if (controller.currentState != DinoState.idle &&
        controller.currentState != DinoState.walking) {
      return false;
    }

    if (event is KeyDownEvent) {
      if (controller.currentState == DinoState.idle &&
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        controller.startWalking();
        isMovingRight = true;
        scale.x = 1;
        _updateAnimation();
        return true;
      } else if (controller.currentState == DinoState.idle &&
          event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        // Mulai jalan ke kiri dari idle
        controller.startWalking();
        isMovingRight = false;
        scale.x = -1;
        _updateAnimation();
        return true;
      }
    }

    // Berhenti jalan saat tombol arrow dilepas
    if (event is KeyUpEvent &&
        controller.currentState == DinoState.walking &&
        (event.logicalKey == LogicalKeyboardKey.arrowRight ||
         event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
      controller.stopWalking();
      _updateAnimation();
      return true;
    }

    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Jika sedang walking, gerakkan dino sesuai arah
    if (controller.currentState == DinoState.walking) {
      if (isMovingRight) {
        position.x += walkSpeed * dt;
        // Jika sampai ujung kanan, berhenti dan kembali ke idle
        if (position.x > game.size.x - size.x) {
          position.x = game.size.x - size.x;
          controller.stopWalking();
          _updateAnimation();
        }
      } else {
        position.x -= walkSpeed * dt;
        // Jika sampai ujung kiri, berhenti dan kembali ke idle
        if (position.x < 0) {
          position.x = 0;
          controller.stopWalking();
          _updateAnimation();
        }
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    controller.handleTap();
    _updateAnimation();
  }
}