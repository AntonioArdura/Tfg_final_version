import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tfg_v1/models/moodVariables.dart';

class EmotionDetail extends StatefulWidget {
  final BbddBox emotion;

  const EmotionDetail({required this.emotion});

  @override
  EmotionDetailState createState() => EmotionDetailState();
}

//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EmotionDetailState extends State<EmotionDetail> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(widget.emotion.date);
    var lastEmotion = getLastEmotionForToday();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
            splashRadius: 3,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          backgroundColor: Colors.blueGrey[800],
          toolbarHeight: 45,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                          tag: 'prueba',
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    8), // Ajusta el radio para personalizar el borde
                                boxShadow: [
                                  BoxShadow(
                                    color: colores[widget.emotion
                                        .emotion]!, // Ajusta el color y la opacidad de la sombra
                                    //spreadRadius: 2, // Ajusta la difusión de la sombra
                                    //blurRadius: 5, // Ajusta el desenfoque de la sombra
                                    // offset: Offset(0,
                                    //     3), // Ajusta el desplazamiento de la sombra en la dirección x e y
                                  ),
                                ],
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: Colors.grey[200],
                                      child: SingleChildScrollView(
                                          child: ListTile(
                                              title: Column(children: [
                                        SizedBox(height: 10),
                                        Text(
                                          'Emotion: ${widget.emotion.emotion}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Date: ${formattedDate}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Area: ${widget.emotion.area}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(height: 10),
                                      ]))))))),
                      SizedBox(height: 8),
                      if (widget.emotion.dairyText.isNotEmpty ||
                          widget.emotion.dairyDescription.isNotEmpty)
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.grey[200],
                            child: ListTile(
                                title: Column(children: [
                                  SizedBox(height: 8),
                                  if (widget.emotion.dairyDescription != null &&
                                      widget
                                          .emotion.dairyDescription.isNotEmpty)
                                    Text(
                                      '${widget.emotion.dairyDescription}',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black87),
                                    ),
                                  // if (widget.emotion.dairyDescription != null &&
                                  //     widget.emotion.dairyDescription.isNotEmpty)
                                  SizedBox(height: 8),
                                ]),
                                subtitle: Column(children: [
                                  if (widget.emotion.dairyText != null &&
                                      widget.emotion.dairyText.isNotEmpty)
                                    Text(
                                      '${widget.emotion.dairyText}',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                                  // if (widget.emotion.dairyText != null &&
                                  //     widget.emotion.dairyText.isNotEmpty)
                                  SizedBox(height: 8),
                                ]))),
                      SizedBox(height: 8),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: ExpansionPanelList(
                              elevation: 0,
                              expandedHeaderPadding: EdgeInsets.zero,
                              expansionCallback: (int index, bool isExpanded) {
                                _toggleExpanded();
                              },
                              children: [
                                ExpansionPanel(
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      //return Container();
                                      return ListTile(
                                        title: Text(
                                          'RATINGS FOR THE EMOTION',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      );
                                    },
                                    body: (widget.emotion.playlistRating != 0.0)
                                        ? Column(
                                            children: [
                                              Center(
                                                  child: Text(
                                                'Utility for the goal emotion',
                                                style: TextStyle(fontSize: 15),
                                              )),
                                              SizedBox(height: 6),
                                              Center(
                                                  child: RatingBar.builder(
                                                initialRating: widget
                                                    .emotion.emotionRating,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 24,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                onRatingUpdate: (rating) {},
                                              )),
                                              SizedBox(height: 16),
                                              Center(
                                                  child: Text(
                                                'Suitability of the songs for emotional influence',
                                                style: TextStyle(fontSize: 15),
                                              )),
                                              SizedBox(height: 6),
                                              Center(
                                                  child: RatingBar.builder(
                                                initialRating: widget
                                                    .emotion.suitabilityRating,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 24,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                onRatingUpdate: (rating) {},
                                              )),
                                              SizedBox(height: 16),
                                              Center(
                                                  child: Text(
                                                'Evaluation of the playlist recommendation',
                                                style: TextStyle(fontSize: 15),
                                              )),
                                              SizedBox(height: 6),
                                              Center(
                                                  child: RatingBar.builder(
                                                initialRating: widget
                                                    .emotion.playlistRating,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 24,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                ignoreGestures: true,
                                                onRatingUpdate: (rating) {},
                                              )),
                                              SizedBox(height: 16),
                                              Center(
                                                  child: Text(
                                                'Influence on emotional state',
                                                style: TextStyle(fontSize: 15),
                                              )),
                                              SizedBox(height: 8),
                                              Center(
                                                child: RatingBar.builder(
                                                  initialRating: widget.emotion
                                                      .suitabilityRating,
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  ignoreGestures: true,
                                                  onRatingUpdate: (rating) {},
                                                ),
                                              ),
                                              SizedBox(height: 16)
                                            ],
                                          )
                                        : (widget.emotion.date ==
                                                lastEmotion.date)
                                            ? Column(children: [
                                                SizedBox(height: 16),
                                                Center(
                                                  child: Text(
                                                      'Please fill out the questionnarie'),
                                                ),
                                                SizedBox(height: 16)
                                              ])
                                            : Column(children: [
                                                SizedBox(height: 16),
                                                Center(
                                                  child: Text(
                                                      'This emotion has no ratings'),
                                                ),
                                                SizedBox(height: 16)
                                              ]),
                                    isExpanded: _isExpanded),
                              ])),
                    ]))));
  }
}
