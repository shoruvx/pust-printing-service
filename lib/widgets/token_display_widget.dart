import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TokenDisplayWidget extends StatelessWidget {
  final String token;

  TokenDisplayWidget({required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            token,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: token));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Token copied to clipboard!'),
              ));
            },
            child: Text('Copy to Clipboard'),
          ),
        ],
      ),
    );
  }
}