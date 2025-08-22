import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/player_sprite_sheet_component.dart';

class MyGame extends FlameGame {
  @override
  void onLoad() async {
    super.onLoad();
    add(PlayerSpriteSheetComponent());
  }
}

void main() async{
  runApp(GameWidget(game: MyGame()));
}