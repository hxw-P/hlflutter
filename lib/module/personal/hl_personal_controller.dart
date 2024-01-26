import 'package:get/get.dart';

class Teacher {
  // rx 变量
  var name = "mabo".obs;
  var age = 30.obs;
}

class HLPersonalController extends GetxController {

  var teacher = Teacher();
  void convertToUpperCase() {
    teacher.name.value = teacher.name.value.toUpperCase();
    update();
  }

}