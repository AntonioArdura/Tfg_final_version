import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/controllers/Logout.dart';
import 'package:tfg_v1/models/navBar.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/DailyScreen.dart';
import 'package:tfg_v1/views/EmotionScreen.dart';
import 'package:tfg_v1/views/HomeScreen.dart';
import 'package:tfg_v1/views/MyPlaylists.dart';
import 'package:tfg_v1/views/QuestionnaireScreen.dart';
import 'package:tfg_v1/views/SearchScreen.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';

class CalendarSummary extends StatefulWidget {
  @override
  _CalendarSummaryState createState() => _CalendarSummaryState();
}

String _selectedDay = DateFormat('dd-MM-yyyy').format(DateTime.now());
DateTime selectedDay = DateTime.now();
final _apiProvider = SpotifyApiProviderList();
late BbddBox emotionToday;

class _CalendarSummaryState extends State<CalendarSummary> {
  late List<DateTime> _dates;

  late String _selectedMonth;
  late DateTime _currentDate;
  late DateTime _lastYearDate;

  @override
  void initState() {
    super.initState();

    // Obtener la fecha actual y la fecha de hace un año
    _currentDate = DateTime.now();
    _lastYearDate = _currentDate.subtract(Duration(days: 365));

    // Inicializar el mes seleccionado con el mes actual
    _selectedMonth = DateFormat('MMMM').format(_currentDate);

    // Inicializar la lista de fechas para el mes actual
    _dates = _generateDatesForMonth(_currentDate);
  }

  List<DateTime> _generateDatesForMonth(DateTime month) {
    final now = DateTime.now();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    if (month.year == now.year && month.month == now.month) {
      return List.generate(now.day, (index) {
        final day = now.day - index;
        return DateTime(month.year, month.month, day);
      });
    } else {
      return List.generate(daysInMonth, (index) {
        final day = daysInMonth - index;
        return DateTime(month.year, month.month, day);
      });
    }
  }

  // String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Summary'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[800],
          toolbarHeight: 45,
          centerTitle: true,
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashRadius: 1.0,
              hoverColor: Colors.transparent,
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Column(
            children: [
              SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: List.generate(_dates.length, (index) {
                    final date = _dates[_dates.length - 1 - index];
                    final day = DateFormat('dd').format(date);
                    final month = DateFormat('MMMM').format(date);
                    final weekday = DateFormat('EEE').format(date);
                    // Filtrar la lista para mostrar solo los días correspondientes al mes seleccionado
                    if (month != _selectedMonth) {
                      return Container();
                    }
                    return InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _selectedDay = DateFormat('dd-MM-yyyy').format(date);
                          selectedDay = date;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 7,
                        height: 50,
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: _selectedDay ==
                                  DateFormat('dd-MM-yyyy').format(date)
                              ? Color.fromARGB(198, 20, 163, 185)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _selectedDay !=
                                        DateFormat('dd-MM-yyyy').format(date)
                                    ? Colors.black45
                                    : Colors.grey[300],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              month,
                              style: TextStyle(
                                fontSize: 8,
                                color: _selectedDay !=
                                        DateFormat('dd-MM-yyyy').format(date)
                                    ? Colors.black45
                                    : Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Contenedor para seleccionar el mes
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón para el mes anterior
                    IconButton(
                      splashRadius: 3,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.arrow_back, size: 14),
                      onPressed: () {
                        setState(() {
                          // Restar un mes al mes actual
                          _currentDate = DateTime(
                              _currentDate.year, _currentDate.month - 1, 1);
                          // Verificar que el mes no sea anterior al mes de hace un año
                          if (_currentDate.isBefore(_lastYearDate)) {
                            _currentDate = _lastYearDate;
                          }
                          // Actualizar el mes seleccionado y la lista de fechas
                          _selectedMonth =
                              DateFormat('MMMM').format(_currentDate);
                          _dates = _generateDatesForMonth(_currentDate);
                        });
                      },
                    ),
                    // Texto para mostrar el mes seleccionado
                    Text(
                      _selectedMonth,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    // Botón para el mes siguiente (siempre que no sea después del mes actual)
                    _currentDate.month < DateTime.now().month ||
                            _currentDate.year < DateTime.now().year
                        ? IconButton(
                            splashRadius: 3,
                            highlightColor: Colors.transparent,
                            icon: Icon(Icons.arrow_forward, size: 14),
                            onPressed: () {
                              setState(() {
                                // Sumar un mes al mes actual
                                _currentDate = DateTime(_currentDate.year,
                                    _currentDate.month + 1, 1);
                                // Actualizar el mes seleccionado y la lista de fechas
                                _selectedMonth =
                                    DateFormat('MMMM').format(_currentDate);
                                _dates = _generateDatesForMonth(_currentDate);
                              });
                            },
                          )
                        : SizedBox(
                            width: 50,
                          ),
                  ],
                ),
              ),
              _selectedDay != ''
                  ? Expanded(child: DailyScreen(date: selectedDay))
                  : Expanded(
                      child: Container(
                      color: Color.fromARGB(87, 27, 159, 180),
                    )),
              Container(
                height: 80,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: navBar(),
                    ),
                    Center(
                      heightFactor: 1,
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Hero(
                            tag: 'selectEmotion',
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      reverseTransitionDuration:
                                          const Duration(seconds: 1),
                                      pageBuilder: (context, animation, _) {
                                        return FadeTransition(
                                            opacity: animation,
                                            child: EmotionScreen());
                                      }),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor:
                                    Color.fromARGB(255, 20, 163, 185),
                              ),
                              child: Icon(Icons.emoji_emotions),
                            )),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            highlightColor: Colors.transparent,
                            splashRadius: 1.0,
                            hoverColor: Colors.transparent,
                            icon: Icon(Icons.home, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SongListPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(-1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          IconButton(
                            highlightColor: Colors.transparent,
                            splashRadius: 1.0,
                            hoverColor: Colors.transparent,
                            icon: Icon(
                              Icons.calendar_month,
                              color: Color.fromARGB(225, 65, 225, 250),
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                            highlightColor: Colors.transparent,
                            splashRadius: 1.0,
                            hoverColor: Colors.transparent,
                            icon: Icon(Icons.bookmark, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      PlaylistPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          IconButton(
                            highlightColor: Colors.transparent,
                            splashRadius: 1.0,
                            hoverColor: Colors.transparent,
                            icon: Icon(Icons.rate_review, color: Colors.white),
                            onPressed: () {
                              BbddBox lastEmotion = getLastEmotionForToday();
                              (lastEmotion.playlistRating == 0.0)
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            QuestionnaireScreen(
                                          lastEmotion: lastEmotion,
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                            'Questionnaire Already Filled',
                                          ),
                                          // content: Text('The questionnaire has already been filled.'),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]));
  }
}
