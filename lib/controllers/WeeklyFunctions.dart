import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:tfg_v1/models/BbddBox.dart';

final emotionsBox = Hive.box<BbddBox>('main');

List<BbddBox> getEmotionsForCurrentWeek() {
  final now = DateTime.now();
  final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
  final endOfWeek =
      DateTime(now.year, now.month, now.day + (7 - now.weekday) + 1);
  return emotionsBox.values.where((emotion) {
    final emotionDate = emotion.date;
    return emotionDate.isAfter(startOfWeek) && emotionDate.isBefore(endOfWeek);
  }).toList();
}

// Map<String, List<BbddBox>> groupEmotionsByDayOfWeek() {
//   List<BbddBox> emotions = getEmotionsForCurrentWeek();

//   Map<String, List<BbddBox>> emotionsByDayOfWeek = {};

//   for (BbddBox emotion in emotions) {
//     DateTime date = DateTime.parse(emotion.date.toString());
//     String dayOfWeek = _getDayOfWeek(date.weekday);

//     if (!emotionsByDayOfWeek.containsKey(dayOfWeek)) {
//       emotionsByDayOfWeek[dayOfWeek] = [];
//     }

//     emotionsByDayOfWeek[dayOfWeek]!.add(emotion);
//   }

//   return emotionsByDayOfWeek;
// }

// Map<String, BbddBox> getLastEmotionByDayOfWeek() {
//   List<BbddBox> emotions = getEmotionsForCurrentWeek();

//   Map<String, BbddBox> lastEmotionByDayOfWeek = {};

//   for (BbddBox emotion in emotions) {
//     DateTime date = DateTime.parse(emotion.date.toString());

//     String dayOfWeek = _getDayOfWeek(date.weekday);

//     if (!lastEmotionByDayOfWeek.containsKey(dayOfWeek)) {
//       lastEmotionByDayOfWeek[dayOfWeek] = emotion;
//     } else {
//       DateTime existingEmotionDate =
//           DateTime.parse(lastEmotionByDayOfWeek[dayOfWeek]!.date.toString());
//       if (date.isAfter(existingEmotionDate)) {
//         lastEmotionByDayOfWeek[dayOfWeek] = emotion;
//       }
//     }
//   }

//   return lastEmotionByDayOfWeek;
// }

BbddBox getLastEmotionForToday() {
  List<BbddBox> emotions = getEmotionsForCurrentWeek();

  BbddBox? lastEmotionForToday;

  for (BbddBox emotion in emotions) {
    DateTime date = DateTime.parse(emotion.date.toString());

    if (date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      if (lastEmotionForToday == null ||
          date.isAfter(DateTime.parse(lastEmotionForToday.date.toString()))) {
        lastEmotionForToday = emotion;
      }
    }
  }

  return lastEmotionForToday!;
}

// String _getDayOfWeek(int dayOfWeek) {
//   switch (dayOfWeek) {
//     case DateTime.monday:
//       return "Lunes";
//     case DateTime.tuesday:
//       return "Martes";
//     case DateTime.wednesday:
//       return "Miércoles";
//     case DateTime.thursday:
//       return "Jueves";
//     case DateTime.friday:
//       return "Viernes";
//     case DateTime.saturday:
//       return "Sábado";
//     case DateTime.sunday:
//       return "Domingo";
//     default:
//       throw Exception("Invalid day of week: $dayOfWeek");
//   }
// }
