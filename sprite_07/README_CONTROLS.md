# Sistem Kontrol Dino

## Deskripsi
Sistem kontrol yang memungkinkan dino bergerak menggunakan arrow keys (kiri dan kanan) dengan animasi yang sesuai dan menghadap ke arah yang benar.

## Komponen Utama

### 1. Direction Enum (`lib/enums/direction.dart`)
Mendefinisikan arah gerakan:
- `Direction.none` - Tidak bergerak
- `Direction.left` - Bergerak ke kiri  
- `Direction.right` - Bergerak ke kanan

### 2. PlayerController (`lib/controllers/player_controller.dart`)
Controller yang menangani input keyboard:
- Mendengarkan tombol Arrow Left dan Arrow Right
- Mengatur kecepatan gerakan (200 pixel per detik)
- Menyediakan callback untuk perubahan arah dan posisi

### 3. PlayerSpriteSheetComponentAnimationFull (`lib/components/player_sprite_sheet_component_animation_full.dart`)
Komponen dino yang telah diperbarui dengan:
- Sistem gerakan menggunakan PlayerController
- Animasi walk saat bergerak, idle saat diam
- Flip sprite berdasarkan arah menghadap
- Batasan gerakan dalam layar

## Cara Kerja

1. **Input Keyboard**: PlayerController mendengarkan tombol Arrow Left/Right
2. **Perubahan Arah**: Ketika tombol ditekan, arah gerakan diperbarui
3. **Animasi**: Animasi berubah dari idle ke walk saat bergerak
4. **Flip Sprite**: Sprite di-flip horizontal saat bergerak ke kiri
5. **Posisi**: Posisi dino diperbarui berdasarkan kecepatan dan waktu
6. **Batasan**: Gerakan dibatasi dalam batas layar

## Kontrol
- **Arrow Left**: Bergerak ke kiri, dino menghadap kiri
- **Arrow Right**: Bergerak ke kanan, dino menghadap kanan
- **Lepas tombol**: Berhenti bergerak, kembali ke animasi idle

## Fitur
- ✅ Gerakan smooth dengan kecepatan yang dapat disesuaikan
- ✅ Animasi yang sesuai dengan gerakan (walk/idle)
- ✅ Dino menghadap sesuai arah gerakan
- ✅ Batasan gerakan dalam layar
- ✅ Sintaks yang mudah dipahami dengan komentar bahasa Indonesia
