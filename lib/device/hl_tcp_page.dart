import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class HLTcpPage extends StatefulWidget {
  @override
  _HLTcpPageState createState() => _HLTcpPageState();
}

class _HLTcpPageState extends State<HLTcpPage> {
  Socket? _socket;
  String _response = '';

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _connectToServer() async {
    final String host = _hostController.text;
    final int port = int.tryParse(_portController.text) ?? 0;
    print("port = $port");
    try {
      _socket = await Socket.connect(host, port);
      _socket?.listen( (List<int> data) {
        setState(() {
          _response = utf8.decode(data);
        });
      },
        onError: (error) {
          print('Error: $error');
        },
        onDone: () {
          print('Disconnected from server');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void _sendMessage() {
    if (_socket == null) return;

    final String message = _messageController.text;
    _socket!.write(message);
    setState(() {
      _response = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCP Debugger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
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
              onPressed: _connectToServer,
              child: Text('Connect'),
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
    print("tcp 释放");
    super.dispose();
  }
}