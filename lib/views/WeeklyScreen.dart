// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:tfg_v1/models/moodVariables.dart';
// import 'package:tfg_v1/models/navBar.dart';

// //import 'package:tfg_v1/screens/emotionScreen.dart';
// import 'package:tfg_v1/controllers/WeeklyFunctions.dart';
// import 'package:tfg_v1/repository/repository.dart';
// import 'package:tfg_v1/views/DailyScreen.dart';
// //import 'package:tfg_v1/models/moodVariables.dart';
// //import 'package:tfg_v1/views/EditProfileScreen.dart';
// import 'package:tfg_v1/views/EmotionScreen.dart';
// import 'package:tfg_v1/views/SearchScreen.dart';
// import 'package:tfg_v1/views/CalendarSummaryScreen.dart';

// import '../models/BbddBox.dart';
// //import 'package:tfg_v1_v2/views/editProfileScreen.dart';

// bool _fontcolor(Color? color) {
//   if (color == Color.fromARGB(242, 255, 242, 126) ||
//       color == Color.fromARGB(255, 249, 112, 102) ||
//       color == Color.fromRGBO(255, 187, 210, 0.851)) {
//     return false;
//   }
//   return true;
// }

// class WeekDaysList extends StatelessWidget {
//   final _apiProvider = SpotifyApiProviderList();
//   late BbddBox emotionToday;
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final emotionsByDay = getLastEmotionByDayOfWeek();
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       if (constraints.maxWidth < 600) {
//         return Scaffold(
//             appBar: AppBar(
//               title: Center(child: Text('Weekly Summary')),
//               automaticallyImplyLeading: false,
//               backgroundColor: Color.fromARGB(198, 20, 163, 185),
//             ),
//             body: Column(children: [
//               Expanded(
//                   child: ListView.builder(
//                 itemCount: emotionsByDay.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   String dayOfWeek = emotionsByDay.keys.elementAt(index);
//                   BbddBox? lastEmotion = emotionsByDay[
//                       emotionsByDay.keys.toList().reversed.elementAt(index)];
//                   Color? cardColor = lastEmotion
//                       ?.color; // Obtener el color de la última emoción seleccionada

//                   Uint8List? img = lastEmotion?.imageBytes;
//                   DateTime fecha = lastEmotion!.date;
//                   return Card(
//                     color: cardColor, // Asignar el color a la Card
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(16, 10, 10, 10),
//                           child: Text(
//                             dayOfWeek,
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
//                           child: Row(
//                             children: [
//                               Image.memory(img!, fit: BoxFit.cover, height: 50),
//                               lastEmotion != null
//                                   ? Padding(
//                                       padding: EdgeInsets.all(10),
//                                       child: Text(
//                                         lastEmotion.emotion,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontStyle: FontStyle.italic,
//                                             color: Colors.black),
//                                       ),
//                                     )
//                                   : Container(),
//                               Spacer(),
//                               IconButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               DailyScreen(date: fecha)));
//                                 },
//                                 icon: Icon(Icons.arrow_forward_ios),
//                                 color: Colors.black,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )),
//               Container(
//                 height: 80,
//                 child: Stack(
//                   children: [
//                     CustomPaint(
//                       size: Size(size.width, 80),
//                       painter: navBar(),
//                     ),
//                     Center(
//                       heightFactor: 1,
//                       child: SizedBox(
//                         width: 100,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EmotionScreen(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: CircleBorder(),
//                             backgroundColor: Color.fromARGB(255, 20, 163, 185),
//                           ),
//                           child: Icon(Icons.emoji_emotions),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: size.width,
//                       height: 80,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             highlightColor: Colors.transparent,
//                             splashRadius: 1.0,
//                             hoverColor: Colors.transparent,
//                             icon: Icon(Icons.home, color: Colors.white),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => WeekDaysList(),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             highlightColor: Colors.transparent,
//                             splashRadius: 1.0,
//                             hoverColor: Colors.transparent,
//                             icon:
//                                 Icon(Icons.calendar_month, color: Colors.white),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CalendarSummary(),
//                                 ),
//                               );
//                             },
//                           ),
//                           Container(
//                             width: size.width * 0.20,
//                           ),
//                           IconButton(
//                             highlightColor: Colors.transparent,
//                             splashRadius: 1.0,
//                             hoverColor: Colors.transparent,
//                             icon: Icon(Icons.bookmark, color: Colors.white),
//                             onPressed: () {},
//                           ),
//                           IconButton(
//                             highlightColor: Colors.transparent,
//                             splashRadius: 1.0,
//                             hoverColor: Colors.transparent,
//                             icon: Icon(Icons.search, color: Colors.white),
//                             onPressed: () async {
//                               emotionToday = getLastEmotionForToday();
//                               final results = await _apiProvider
//                                   .search(emotionToday.emotion);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => SearchScreen(
//                                             results: results,
//                                           )));
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]));
//       } else {
//         return Scaffold(
//             appBar: AppBar(
//               title: Center(child: Text('Weekly Summary')),
//               automaticallyImplyLeading: false,
//               backgroundColor: Color.fromARGB(198, 20, 163, 185),
//             ),
//             drawer: CustomDrawer(),
//             body: Stack(children: [
//               ListView.builder(
//                 itemCount: emotionsByDay.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   String dayOfWeek = emotionsByDay.keys.elementAt(index);
//                   BbddBox? lastEmotion = emotionsByDay[
//                       emotionsByDay.keys.toList().reversed.elementAt(index)];

//                   Color? cardColor = lastEmotion
//                       ?.color; // Obtener el color de la última emoción seleccionada

//                   Uint8List? img = lastEmotion?.imageBytes;
//                   DateTime fecha = lastEmotion!.date;
//                   return Card(
//                     color: cardColor, // Asignar el color a la Card
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(16, 10, 10, 10),
//                           child: Text(
//                             dayOfWeek,
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
//                           child: Row(
//                             children: [
//                               Image.memory(img!, fit: BoxFit.cover, height: 50),
//                               lastEmotion != null
//                                   ? Padding(
//                                       padding: EdgeInsets.all(10),
//                                       child: Text(
//                                         lastEmotion.emotion,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontStyle: FontStyle.italic,
//                                             color: Colors.black),
//                                       ),
//                                     )
//                                   : Container(),
//                               Spacer(),
//                               IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios),
//                                 color: Colors.black,
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               DailyScreen(date: fecha)));
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ]));
//       }
//     });
//   }
// }
