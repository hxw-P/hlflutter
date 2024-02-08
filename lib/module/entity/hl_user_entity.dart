import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HLUserEntity {
  String? userName = '';
  String? email = '';

  HLUserEntity({
    this.userName,
    this.email,
  });

  HLUserEntity fromMap(Map<String, dynamic> map) => HLUserEntity(
    userName: map['username'],
    email: map['email'],
  );
}
