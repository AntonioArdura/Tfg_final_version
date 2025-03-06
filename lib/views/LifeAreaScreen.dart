import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/views/NoteScreen.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';

class LifeAreaPage extends StatefulWidget {
  final String feel;
  final DateTime day;
  //final Color color;
  //final Uint8List image;

  const LifeAreaPage({
    required this.feel,
    required this.day,
    //required this.color,
    //required this.image
  });
  @override
  _LifeAreaPageState createState() => _LifeAreaPageState();
}

class _LifeAreaPageState extends State<LifeAreaPage> {
  List<String> _lifeAreas = ['Work', 'Home', 'Sport', 'Car', 'Leisure'];

  final areaImages = [
    'lib/assets/work.png',
    'lib/assets/home.png',
    'lib/assets/sport.png',
    'lib/assets/coche.png',
    'lib/assets/leisure.png'
  ];
  String _selectedArea = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Hero(tag: 'lifeArea', child: Text('Select one life area'))),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[800],
        toolbarHeight: 45,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _lifeAreas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Cantidad de columnas
                childAspectRatio: 1, // Relación de aspecto de las tarjetas
              ),
              itemBuilder: (BuildContext context, int index) {
                final area = _lifeAreas[index];
                final areaImage = areaImages[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedArea = area;
                    });
                  },
                  child: Card(
                    color: _selectedArea == area
                        ? Color.fromARGB(198, 20, 163, 185)
                        : Colors.white,
                    child: Container(
                      height: 150,
                      child: Column(
                        children: [
                          SizedBox(height: 35),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(
                                areaImage,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                area,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedArea == area
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: Hero(
                tag: 'notes',
                child: TextButton(
                  onPressed: _selectedArea == null || _selectedArea == ''
                      ? null
                      : () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                reverseTransitionDuration:
                                    const Duration(seconds: 1),
                                pageBuilder: (context, animation, _) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: DiaryScreen(
                                        feel: widget.feel,
                                        day: widget.day,
                                        area: _selectedArea),
                                  );
                                }),
                          );
                        },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Color.fromARGB(198, 20, 163, 185);
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(150, 20)),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
