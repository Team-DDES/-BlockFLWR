import 'package:get/get.dart';

//DB형식으로 이 컨트롤러를 사용하고자 합니다.
class UserController extends GetxController {
   RxString address = "".obs;
   RxString signature = "".obs;
   RxString type = "".obs;
   RxBool walletConnect = false.obs;
}

late final UserController userController;
