import 'package:shared_preferences/shared_preferences.dart';

// Guardar el token de sesión
Future<void> saveUserSession(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userToken', token);
}

// Obtener el token de sesión
Future<String?> getUserSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userToken');
}

// Borrar la sesión
Future<void> clearUserSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userToken');
}
