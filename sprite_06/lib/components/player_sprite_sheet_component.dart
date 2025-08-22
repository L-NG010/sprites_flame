import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

class PlayerSpriteSheetComponent extends SpriteComponent with HasGameReference{
  late double screenWidth;
  late double screenHeight;

  late double centerX;
  late double centerY;

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  @override
  void onLoad() async {
    final spriteImage = await Flame.images.load('dino.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    sprite = spriteSheet.getSprite(2,1);

    screenWidth = game.size.x;
    screenHeight = game.size.y;

    size = Vector2(spriteSheetWidth, spriteSheetHeight);

    centerX = (screenWidth/2)-(spriteSheetHeight/2);
    centerY = (screenHeight/2)-(spriteSheetWidth/2);

    position = Vector2(centerX, centerY);
  }
}