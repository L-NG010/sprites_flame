import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../utils/create_animation_by_limit.dart';
import '../enums/direction.dart';
import '../controllers/player_controller.dart';

class PlayerSpriteSheetComponentAnimationFull extends SpriteAnimationComponent with HasGameReference, TapCallbacks {
  late double screenWidth;
  late double screenHeight;

  late double centerX;
  late double centerY;

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;

  late SpriteAnimation deadAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation walkAnimation;

  /// Controller untuk mengatur gerakan player
  late PlayerController playerController;
  
  /// Arah gerakan saat ini
  Direction currentDirection = Direction.none;
  
  /// Apakah player sedang menghadap ke kiri
  bool isFacingLeft = false;
  
  /// State player saat ini
  bool isRunning = false;
  bool isJumping = false;
  bool isDead = false;

  @override
  void onLoad() async {
    final spriteImage = await Flame.images.load('dino_full.png');
    final spriteSheet = SpriteSheet(
      image: spriteImage,
      srcSize: Vector2(spriteSheetWidth, spriteSheetHeight),
    );

    // inisialisasi animasi
    deadAnimation = spriteSheet.createAnimationByLimit(
      xInit: 0,
      yInit: 0,
      step: 8,
      sizeX: 5,
      stepTime: .08,
    );

    idleAnimation = spriteSheet.createAnimationByLimit(
      xInit: 1,
      yInit: 2,
      step: 10,
      sizeX: 5,
      stepTime: .08,
    );

    jumpAnimation = spriteSheet.createAnimationByLimit(
      xInit: 3,
      yInit: 0,
      step: 12,
      sizeX: 5,
      stepTime: .08,
    );

    runAnimation = spriteSheet.createAnimationByLimit(
      xInit: 5,
      yInit: 0,
      step: 8,
      sizeX: 5,
      stepTime: .08,
    );

    walkAnimation = spriteSheet.createAnimationByLimit(
      xInit: 6,
      yInit: 2,
      step: 10,
      sizeX: 5,
      stepTime: .08,
    );
    // end

    // Set animasi awal ke idle
    animation = idleAnimation;

    screenWidth = game.size.x;
    screenHeight = game.size.y;

    // Set ukuran sprite yang lebih kecil untuk tampilan yang lebih baik
    final double displayWidth = spriteSheetWidth * 0.3; // Skala 30% dari ukuran asli
    final double displayHeight = spriteSheetHeight * 0.3;
    
    size = Vector2(displayWidth, displayHeight);

    // Posisi awal di tengah layar dengan offset yang lebih baik
    centerX = (screenWidth / 2) - (displayWidth / 2);
    centerY = (screenHeight / 2) - (displayHeight / 2);

    position = Vector2(centerX, centerY);

    // Inisialisasi player controller
    _initializeController();
  }

  /// Menginisialisasi controller untuk mengatur gerakan player
  void _initializeController() {
    playerController = PlayerController();
    
    // Tambahkan controller ke game agar bisa menerima input keyboard
    game.add(playerController);
    
    // Set callback untuk perubahan arah
    playerController.onDirectionChanged = (Direction direction) {
      currentDirection = direction;
      _updateAnimation();
      _updateFacingDirection();
    };
    
    // Set callback untuk perubahan state
    playerController.onStateChanged = (bool running, bool jumping, bool dead) {
      isRunning = running;
      isJumping = jumping;
      isDead = dead;
      _updateAnimation();
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update posisi berdasarkan controller dengan gerakan yang smooth
    if (currentDirection != Direction.none) {
      final velocity = playerController.getVelocity();
      position += velocity * dt;
      
      // Batasi gerakan dalam layar
      _constrainToScreen();
    }
  }

  /// Memperbarui animasi berdasarkan arah gerakan dan state
  void _updateAnimation() {
    // Prioritas: Dead > Jumping > Running > Walking > Idle
    if (isDead) {
      animation = deadAnimation;
    } else if (isJumping) {
      animation = jumpAnimation;
    } else if (isRunning && currentDirection != Direction.none) {
      animation = runAnimation;
    } else if (currentDirection != Direction.none) {
      animation = walkAnimation;
    } else {
      animation = idleAnimation;
    }
  }

  /// Memperbarui arah menghadap player
  void _updateFacingDirection() {
    switch (currentDirection) {
      case Direction.left:
        isFacingLeft = true;
        break;
      case Direction.right:
        isFacingLeft = false;
        break;
      case Direction.none:
        // Tidak mengubah arah menghadap saat tidak bergerak
        break;
    }
    
    // Flip sprite berdasarkan arah menghadap
    // Menggunakan scale untuk flip horizontal
    if (isFacingLeft) {
      scale.x = -1;
    } else {
      scale.x = 1;
    }
  }

  /// Membatasi gerakan player dalam batas layar
  void _constrainToScreen() {
    // Batasi gerakan horizontal menggunakan ukuran display yang sebenarnya
    if (position.x < 0) {
      position.x = 0;
    } else if (position.x > screenWidth - size.x) {
      position.x = screenWidth - size.x;
    }
    
    // Batasi gerakan vertikal menggunakan ukuran display yang sebenarnya
    if (position.y < 0) {
      position.y = 0;
    } else if (position.y > screenHeight - size.y) {
      position.y = screenHeight - size.y;
    }
  }
  
  /// Handler untuk tap pada dinosaur
  @override
  void onTapDown(TapDownEvent event) {
    // Toggle antara state mati dan idle
    if (isDead) {
      // Jika sedang mati, kembalikan ke idle
      playerController.setDead(false);
    } else {
      // Jika tidak mati, ubah ke state mati
      playerController.setDead(true);
    }
  }
}
