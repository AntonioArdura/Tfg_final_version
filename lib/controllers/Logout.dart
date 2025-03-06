import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/controllers/SpotifyControllers.dart';
import 'package:tfg_v1/models/BbddBox.dart';
import 'package:tfg_v1/repository/repository.dart';
import 'package:tfg_v1/views/LoginScreen.dart';
import 'package:tfg_v1/views/SplashScreen.dart';

final emotionsBox = Hive.box<BbddBox>('main');

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
            },
            child: Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              //emotionsBox.close();
              await logoutAndNavigateToLoginScreen(
                  context); // Cerrar sesión y navegar a la pantalla de inicio de sesión
            },
            child: Text('Accept'),
          ),
        ],
      );
    },
  );
}

Future<void> logoutAndNavigateToLoginScreen(BuildContext context) async {
  await SpotifyApiProvider().logout();

  // Eliminar los datos de sesión almacenados en SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('access_token');
  prefs.remove('token_type');
  prefs.remove('refresh_token');
  prefs.remove('logged');

  // Navegar a la pantalla de inicio de sesión
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SplashScreen()),
  );
}
