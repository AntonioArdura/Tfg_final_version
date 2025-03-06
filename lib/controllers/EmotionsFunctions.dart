import 'package:hive_flutter/hive_flutter.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/moodVariables.dart';
import 'dart:math';

Future<void> openMainBox() async {
  await Hive.openBox<BbddBox>('main');
}

List<String> obtenerCaminoOptimo(String emocionFinal, String emocionInicial) {
  String clave = '$emocionInicial' + '_' + '$emocionFinal';
  List<String>? caminoOptimo = caminosOptimos[clave];
  print(caminoOptimo);
  return caminoOptimo ?? [];
}

Map<String, List<double>> progressiveChangesOnPath(List<String> emotionalPath) {
  Map<String, Map<String, List<double>>> emotionValues = {
    'Happy': {
      'target_tempo': [120.0, 140.0],
      'target_energy': [0.7, 0.9],
      'target_valence': [0.6, 0.8],
      'target_danceability': [0.7, 0.9],
      'target_loudness': [-8.0, -6.0]
    },
    'Frustrated': {
      'target_tempo': [90.0, 110.0],
      'target_energy': [0.5, 0.7],
      'target_valence': [0.3, 0.5],
      'target_danceability': [0.4, 0.6],
      'target_loudness': [-10.0, -8.0]
    },
    'Angry!': {
      'target_tempo': [100.0, 120.0],
      'target_energy': [0.8, 1.0],
      'target_valence': [0.4, 0.6],
      'target_danceability': [0.7, 0.9],
      'target_loudness': [-6.0, -4.0]
    },
    'In love': {
      'target_tempo': [80.0, 100.0],
      'target_energy': [0.6, 0.8],
      'target_valence': [0.7, 0.9],
      'target_danceability': [0.6, 0.8],
      'target_loudness': [-8.0, -6.0]
    },
    'Awful': {
      'target_tempo': [40.0, 60.0],
      'target_energy': [0.1, 0.3],
      'target_valence': [0.1, 0.3],
      'target_danceability': [0.1, 0.3],
      'target_loudness': [-16.0, -14.0]
    },
    'Tired': {
      'target_tempo': [60.0, 80.0],
      'target_energy': [0.3, 0.5],
      'target_valence': [0.2, 0.4],
      'target_danceability': [0.2, 0.4],
      'target_loudness': [-12.0, -10.0]
    },
    'Relaxed': {
      'target_tempo': [80.0, 100.0],
      'target_energy': [0.4, 0.6],
      'target_valence': [0.5, 0.7],
      'target_danceability': [0.4, 0.6],
      'target_loudness': [-10.0, -8.0]
    },
    'Excited': {
      'target_tempo': [140.0, 160.0],
      'target_energy': [0.9, 1.0],
      'target_valence': [0.8, 1.0],
      'target_danceability': [0.8, 1.0],
      'target_loudness': [-4.0, -2.0]
    },
  };

  Map<String, List<double>> progressiveChanges = {};

  if (emotionalPath.length == 1) {
    // Handle case with only one emotion
    String emotion = emotionalPath[0];
    Map<String, dynamic>? emotionConfig = emotionValues[emotion];

    if (emotionConfig != null) {
      for (String characteristic in emotionConfig.keys) {
        List<double> valueRange = emotionConfig[characteristic];
        List<double> changeSequence = [];

        double value = Random().nextDouble() * (valueRange[1] - valueRange[0]) +
            valueRange[0];
        for (int j = 0; j < 10; j++) {
          changeSequence.add(value);
        }

        progressiveChanges[characteristic] = changeSequence;
      }
    }
  } else {
    // Handle case with multiple emotions
    for (int i = 0; i < emotionalPath.length - 1; i++) {
      String startEmotion = emotionalPath[i];
      String targetEmotion = emotionalPath[i + 1];

      Map<String, dynamic>? startValues = emotionValues[startEmotion];
      Map<String, dynamic>? targetValues = emotionValues[targetEmotion];

      for (String characteristic in startValues!.keys) {
        List<double> startValueRange = startValues[characteristic];
        List<double> targetValueRange = targetValues?[characteristic];

        double startValue =
            Random().nextDouble() * (startValueRange[1] - startValueRange[0]) +
                startValueRange[0];
        double targetValue = Random().nextDouble() *
                (targetValueRange[1] - targetValueRange[0]) +
            targetValueRange[0];

        List<double> changeSequence = [];
        for (int j = 0; j < 10; j++) {
          double value = startValue + ((targetValue - startValue) / 10) * j;
          changeSequence.add(value);
        }

        if (!progressiveChanges.containsKey(characteristic)) {
          progressiveChanges[characteristic] = [];
        }

        progressiveChanges[characteristic]?.addAll(changeSequence);
      }
    }
  }
  print(progressiveChanges);
  return progressiveChanges;
}
