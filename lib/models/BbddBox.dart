import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:typed_data';

@HiveType(typeId: 0)
class BbddBox extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String emotion;

  @HiveField(2)
  String area;

  @HiveField(3)
  String dairyDescription;

  @HiveField(4)
  String dairyText;

  @HiveField(5)
  double emotionRating; // Cambiado a double

  @HiveField(6)
  double suitabilityRating; // Cambiado a double

  @HiveField(7)
  double playlistRating; // Cambiado a double

  @HiveField(8)
  double effectiveRating; // Cambiado a double

  BbddBox(
      this.date,
      this.emotion,
      this.area,
      this.dairyDescription,
      this.dairyText,
      this.emotionRating,
      this.suitabilityRating,
      this.playlistRating,
      this.effectiveRating);
}

class BoxAdapter extends TypeAdapter<BbddBox> {
  @override
  final int typeId = 0;

  @override
  BbddBox read(BinaryReader reader) {
    final dateMillis = reader.readUint32();
    final date = DateTime.fromMillisecondsSinceEpoch(dateMillis);

    final emotion = reader.readString();
    final area = reader.readString();
    final dairyDescription = reader.readString();
    final dairyText = reader.readString();
    final emotionRating = reader.readDouble(); // Cambiado a readDouble()
    final suitabilityRating = reader.readDouble(); // Cambiado a readDouble()
    final playlistRating = reader.readDouble(); // Cambiado a readDouble()
    final effectiveRating = reader.readDouble(); // Cambiado a readDouble()

    return BbddBox(date, emotion, area, dairyDescription, dairyText,
        emotionRating, suitabilityRating, playlistRating, effectiveRating);
  }

  @override
  void write(BinaryWriter writer, BbddBox obj) {
    writer.writeUint32(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.emotion);
    writer.writeString(obj.area);
    writer.writeString(obj.dairyText);
    writer.writeString(obj.dairyDescription);
    writer.writeDouble(obj.emotionRating); // Cambiado a writeDouble()
    writer.writeDouble(obj.suitabilityRating); // Cambiado a writeDouble()
    writer.writeDouble(obj.playlistRating); // Cambiado a writeDouble()
    writer.writeDouble(obj.effectiveRating); // Cambiado a writeDouble()
  }
}
