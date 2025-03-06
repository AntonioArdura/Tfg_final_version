import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/models/moodVariables.dart';
import 'package:tfg_v1/views/EmotionDetailScreen.dart';

final emotionsBox = Hive.box<BbddBox>('main');

class DailyScreen extends StatelessWidget {
  final DateTime date;

  const DailyScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    final emotionsForDay = getEmotionsForDay(date);
    //final title = DateFormat('EEEE, dd MMMM yyyy').format(date);

    return Scaffold(
      //backgroundColor: Color.fromARGB(87, 27, 159, 180),
      body: Container(
        //color: Color.fromARGB(145, 1, 25, 28),
        child: ListView.builder(
          itemCount: emotionsForDay.length,
          itemBuilder: (context, index) {
            final emotion = emotionsForDay.reversed.toList()[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          reverseTransitionDuration: const Duration(seconds: 1),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                                opacity: animation,
                                child: EmotionDetail(emotion: emotion));
                          }),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                          title: Row(
                            children: [
                              if (emotionImages[emotion.emotion] != null)
                                Hero(
                                    tag: 'prueba',
                                    child: Image.asset(
                                      emotionImages[emotion.emotion]!,
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    )),
                              if (emotionImages[emotion.emotion] != null)
                                SizedBox(
                                  width: 8,
                                ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    emotion.emotion,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: emotion.dairyDescription != ''
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 3),
                                          child: Text(
                                            emotion.dairyDescription,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ])
                              : SizedBox(
                                  height: 0.5,
                                ),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('H:mm').format(emotion.date),
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 5, 0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: areaColors[emotion.area]
                                            ?.withOpacity(0.5) ??
                                        Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: areaColors[emotion.area] ??
                                          Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    emotion.area,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                ),
                              ])),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }

  List<BbddBox> getEmotionsForDay(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day + 1);
    return emotionsBox.values.where((emotion) {
      final emotionDate = emotion.date;
      return emotionDate.isAfter(startOfDay) && emotionDate.isBefore(endOfDay);
    }).toList();
  }
}
