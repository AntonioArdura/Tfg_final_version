import 'package:flutter/material.dart';
import 'package:tfg_v1/views/CalendarSummaryScreen.dart';
import 'package:tfg_v1/views/WeeklyScreen.dart';
//import 'package:tfg_v1/screens/editProfileScreen.dart';

class navBar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.white, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(198, 20, 163, 185),
            ),
            currentAccountPicture: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigator.push(
                // context,
                //PageRouteBuilder(
                //pageBuilder: (context, animation, secondaryAnimation) =>
                //EditProfileScreen(),
                //),
                //);
              },
            ),
            accountName: Text("Nombre de usuario"),
            accountEmail: Text("email@example.com"),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CalendarSummary(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configuration"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Acerca de"),
          ),
        ],
      ),
    );
  }
}
