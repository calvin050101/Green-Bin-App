import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../constants/assets.dart';
import '../../widgets/back_button.dart';

class TermsPage extends StatefulWidget {
  static String routeName = "/terms";
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  String content = "";

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  Future<void> loadContent() async {
    final text = await rootBundle.loadString(AppAssets.termsAndConditions);
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
        title: Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(
          data: content,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
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
