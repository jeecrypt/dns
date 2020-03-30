

// flutter packages pub run build_runner watch
// flutter packages pub run build_runner build
import 'package:auto_route/auto_route_annotations.dart';
import 'pages/GetKeyPage.dart';
import 'pages/SendDataPage.dart';

@MaterialAutoRouter()
class $Router {
 // use @initial or @CupertinoRoute(initial: true) to annotate your initial route.
  @initial
  GetKeyPage getKeyPage;
  SendDataPage sendDataPage;
}