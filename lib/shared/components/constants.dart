//
//
// import '../../modules/login/shop_login_screen.dart';
// import '../network/local/cache_helper.dart';
// import 'components.dart';
//
import 'package:social_app_flutter_firebase/layout/home/cubit/cubit.dart';

import '../../modules/login/login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'login');

  CacheHelper.removeData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
      HomeCubit.get(context).currentIndex = 0;
    }
  });
}
//
// // method to print full text
void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
//
//
// String token = '';
 String? uId = '';



