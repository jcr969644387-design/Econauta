import 'package:audioplayers/audioplayers.dart';

/// Contrato del reproductor de efectos de sonido.
///
/// Se define como abstraccion para poder sustituirlo en las pruebas, donde
/// los plugins nativos de audio no estan disponibles.
abstract class SoundPlayer {
  /// Reproduce el archivo indicado, relativo a la carpeta `assets`.
  Future<void> play(String asset, double volume);

  /// Libera los recursos nativos.
  Future<void> dispose();
}

/// Implementacion real basada en el paquete `audioplayers`.
class AudioPlayersSoundPlayer implements SoundPlayer {
  AudioPlayer? _player;

  @override
  Future<void> play(String asset, double volume) async {
    final player = _player ??= AudioPlayer();
    await player.stop();
    await player.play(AssetSource(asset), volume: volume);
  }

  @override
  Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
  }
}

/// Reproductor silencioso que solo anota los sonidos solicitados.
///
/// Es el que usan las pruebas para verificar que cada accion suena.
class RecordingSoundPlayer implements SoundPlayer {
  /// Archivos solicitados en orden.
  final List<String> played = <String>[];

  @override
  Future<void> play(String asset, double volume) async {
    played.add(asset);
  }

  @override
  Future<void> dispose() async {
    played.clear();
  }
}
