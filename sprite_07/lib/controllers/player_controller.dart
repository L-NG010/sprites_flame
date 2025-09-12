import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../enums/direction.dart';

/// Controller untuk menangani input keyboard dan menggerakkan player
class PlayerController extends Component {
  /// Kecepatan gerakan player (pixel per detik)
  final double moveSpeed = 200.0;
  
  /// Arah gerakan saat ini
  Direction currentDirection = Direction.none;
  
  /// Callback yang dipanggil ketika arah berubah
  Function(Direction)? onDirectionChanged;
  
  /// Callback yang dipanggil ketika posisi berubah
  Function(Vector2)? onPositionChanged;

  /// Set untuk melacak tombol yang sedang ditekan
  final Set<LogicalKeyboardKey> _pressedKeys = <LogicalKeyboardKey>{};

  @override
  void onLoad() {
    super.onLoad();
    // Mendaftarkan listener untuk keyboard input
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  /// Handler untuk keyboard events
  bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
      _updateDirectionFromPressedKeys();
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
      _updateDirectionFromPressedKeys();
    }
    return false;
  }

  /// Memperbarui arah berdasarkan tombol yang sedang ditekan
  void _updateDirectionFromPressedKeys() {
    Direction newDirection = Direction.none;
    
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      newDirection = Direction.left;
    } else if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      newDirection = Direction.right;
    }
    
    _updateDirection(newDirection);
  }

  /// Memperbarui arah gerakan
  void _updateDirection(Direction newDirection) {
    if (newDirection != currentDirection) {
      currentDirection = newDirection;
      onDirectionChanged?.call(currentDirection);
    }
  }

  /// Mendapatkan velocity berdasarkan arah saat ini
  Vector2 getVelocity() {
    switch (currentDirection) {
      case Direction.left:
        return Vector2(-moveSpeed, 0);
      case Direction.right:
        return Vector2(moveSpeed, 0);
      case Direction.none:
        return Vector2.zero();
    }
  }

  /// Memperbarui posisi berdasarkan velocity
  void updatePosition(Vector2 currentPosition, double dt) {
    if (currentDirection != Direction.none) {
      final velocity = getVelocity();
      final newPosition = currentPosition + velocity * dt;
      onPositionChanged?.call(newPosition);
    }
  }

  @override
  void onRemove() {
    // Membersihkan listener ketika component dihapus
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    super.onRemove();
  }
}