///请求响应model
class ResponseEntity {
  Object data;
  int errorCode;
  String errorMsg;

  ResponseEntity({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
  });

  factory ResponseEntity.fromJson(Map<String, dynamic> json) => ResponseEntity(
        data: json['data'] ?? {},
        errorCode: json['errorCode'],
        errorMsg: json['errorMsg'],
      );

  Map<String, dynamic> toJson() => {
        'data': data,
        'errorCode': errorCode,
        'errorMsg': errorMsg,
      };
}
