import 'package:flutter/material.dart';

class LoadingRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 140),
          Text(
            'Generating recommendation...', // Texto personalizado de indicación de carga
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Color del texto
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/WaveSound.gif'),
        ),
      ),
    );
  }
}
