import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/back_button.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String content = "";

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  Future<void> loadContent() async {
    final text = await rootBundle.loadString("lib/assets/privacy_policy.md");
    setState(() {
      content = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
        title: Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              h1: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
              p: TextStyle(fontFamily: 'OpenSans'),
              strong: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
      ),
    );
  }
}
