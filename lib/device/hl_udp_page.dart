import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HLUdpPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HLUdpPageState createState() => _HLUdpPageState();
}

class _HLUdpPageState extends State<HLUdpPage> {
  RawDatagramSocket? _socket; //? _socket可以为空  dart强制执行null检查
  String _response = '';
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _startListening() async {
    final String host = _hostController.text;
    final int port = int.tryParse(_portController.text) ??
        0; //expr1 ?? expr2 如果expr1非空，则返回其值；否则，计算并返回expr2的值
    print("ip = ${InternetAddress.anyIPv4}");

    try {
      _socket = await RawDatagramSocket.bind(host, port);
      _socket!.listen((RawSocketEvent event) {
        //! 空断言运算符 将表达式转换为其基础的不可空类型，如果转换失败，则抛出运行时异常；
        if (event == RawSocketEvent.read) {
          final datagram = _socket!.receive();
          if (datagram != null) {
            final message = utf8.decode(datagram.data);
            setState(() {
              _response = message;
            });
          }
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _sendMessage() {
    if (_socket == null) return;

    final String host = _hostController.text;
    final int port = int.tryParse(_portController.text) ?? 0;
    final String message = _messageController.text;
    final address = InternetAddress(host);

    _socket!.send(utf8.encode(message), address, port);
    setState(() {
      _response = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UDP Debugger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _hostController,
              decoration: InputDecoration(labelText: 'Host'),
            ),
            TextField(
              controller: _portController,
              decoration: InputDecoration(labelText: 'Port'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _startListening,
              child: Text('Start Listening'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 10),
            Text('Response:'),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //请在 TextEditingController 使用完毕时将其 dispose ，从而确保所有被这个对象所使用的资源被释放。
    _hostController.dispose();
    _portController.dispose();
    _messageController.dispose();

    _socket?.close();
    print("udp 释放");
    super.dispose();
  }
}
