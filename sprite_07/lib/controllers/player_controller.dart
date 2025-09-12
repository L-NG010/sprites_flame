import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../enums/direction.dart';

/// Controller untuk menangani input keyboard dan menggerakkan player
class PlayerController extends Component {
  /// Kecepatan gerakan player (pixel per detik)
  final double moveSpeed = 200.0;
  
  /// Kecepatan lari player (pixel per detik)
  final double runSpeed = 350.0;
  
  /// Arah gerakan saat ini
  Direction currentDirection = Direction.none;
  
  /// Apakah sedang berlari
  bool isRunning = false;
  
  /// Apakah sedang melompat
  bool isJumping = false;
  
  /// Apakah sedang mati
  bool isDead = false;
  
  /// Callback yang dipanggil ketika arah berubah
  Function(Direction)? onDirectionChanged;
  
  /// Callback yang dipanggil ketika posisi berubah
  Function(Vector2)? onPositionChanged;
  
  /// Callback yang dipanggil ketika state berubah
  Function(bool, bool, bool)? onStateChanged;

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
    bool newIsRunning = false;
    bool newIsJumping = false;
    
    // Handle movement keys
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      newDirection = Direction.left;
    } else if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      newDirection = Direction.right;
    }
    
    // Handle shift key for running
    if (_pressedKeys.contains(LogicalKeyboardKey.shiftLeft) || 
        _pressedKeys.contains(LogicalKeyboardKey.shiftRight)) {
      newIsRunning = true;
    }
    
    // Handle space key for jumping
    if (_pressedKeys.contains(LogicalKeyboardKey.space)) {
      newIsJumping = true;
    }
    
    _updateDirection(newDirection);
    _updateStates(newIsRunning, newIsJumping);
  }

  /// Memperbarui arah gerakan
  void _updateDirection(Direction newDirection) {
    if (newDirection != currentDirection) {
      currentDirection = newDirection;
      onDirectionChanged?.call(currentDirection);
    }
  }
  
  /// Memperbarui state player
  void _updateStates(bool newIsRunning, bool newIsJumping) {
    if (newIsRunning != isRunning || newIsJumping != isJumping) {
      isRunning = newIsRunning;
      isJumping = newIsJumping;
      onStateChanged?.call(isRunning, isJumping, isDead);
    }
  }
  
  /// Method untuk mengatur state mati
  void setDead(bool dead) {
    if (isDead != dead) {
      isDead = dead;
      onStateChanged?.call(isRunning, isJumping, isDead);
    }
  }

  /// Mendapatkan velocity berdasarkan arah saat ini
  Vector2 getVelocity() {
    if (isDead) return Vector2.zero();
    
    double speed = isRunning ? runSpeed : moveSpeed;
    
    switch (currentDirection) {
      case Direction.left:
        return Vector2(-speed, 0);
      case Direction.right:
        return Vector2(speed, 0);
      case Direction.none:
        return Vector2.zero();
    }
  }

  /// Memperbarui posisi berdasarkan velocity
  void updatePosition(Vector2 currentPosition, double dt) {
    if (currentDirection != Direction.none && !isDead) {
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