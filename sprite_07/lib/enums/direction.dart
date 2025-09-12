/// Enum untuk menentukan arah gerakan dino
enum Direction {
  /// Tidak bergerak
  none,
  /// Bergerak ke kiri
  left,
  /// Bergerak ke kanan
  right,
}

/// Enum untuk menentukan state player
enum PlayerState {
  /// Idle state
  idle,
  /// Walking state
  walking,
  /// Running state
  running,
  /// Jumping state
  jumping,
  /// Dead state
  dead,
}