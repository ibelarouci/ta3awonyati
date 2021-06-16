import 'package:intl/intl.dart';

class Constants {
  static const String p_a_t = '';
  static const String appName = 'TA3AWONYATI';
  static const String logoTag = 'near.huscarl.loginsample.logo';
  static const String titleTag = 'near.huscarl.loginsample.title';

  /* _getAndSaveToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await _getTokenFromHttp();
  await prefs.setInt('jwt', token);
}*/
  static String getStringDate(int ndate) {
    DateTime d = DateTime.fromMillisecondsSinceEpoch(ndate);
    return DateFormat('dd-MM-yyyy').format(d);
  }
}
