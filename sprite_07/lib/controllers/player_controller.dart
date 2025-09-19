enum DinoState {
  idle,
  walking,
  running,
  jumping,
  dead,
}

class DinoController {
  DinoState currentState = DinoState.idle;
  Function()? onStateChanged;

  void startWalking() {
    if (currentState == DinoState.idle) {
      currentState = DinoState.walking;
      onStateChanged?.call();
    }
  }

  void stopWalking() {
    if (currentState == DinoState.walking) {
      currentState = DinoState.idle;
      onStateChanged?.call();
    }
  }

  void handleTap() {
    // Hanya bisa tap untuk mengubah state jika tidak sedang walking
    if (currentState == DinoState.walking) return;

    // Tap langsung ke running dari idle, running, jumping, dead
    switch (currentState) {
      case DinoState.idle:
        currentState = DinoState.running;
        break;
      case DinoState.running:
        currentState = DinoState.jumping;
        break;
      case DinoState.jumping:
        currentState = DinoState.dead;
        break;
      case DinoState.dead:
        currentState = DinoState.idle;
        break;
      case DinoState.walking:
        // Tidak bisa di-tap saat walking
        break;
    }
    onStateChanged?.call();
  }
}