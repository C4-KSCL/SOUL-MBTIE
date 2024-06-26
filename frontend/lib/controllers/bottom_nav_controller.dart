import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  //Get.find()는 다른 곳에서 해당 타입의 컨트롤러 인스턴스를 찾아 반환
  static BottomNavigationBarController get to => Get.find();

  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    //RxInt 타입의 경우, .value를 생략하고 그냥 괄호를 사용하여 값을 할당하는 것이 가능
    //selectedIndex.value=index; 와 selectedIndex(index);는 같음
    selectedIndex.value = index;
  }
}
