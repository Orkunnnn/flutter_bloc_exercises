import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage._();

  static Route<String> route() => MaterialPageRoute(
        builder: (context) => const SearchPage._(),
      );

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textEditingController = TextEditingController();

  String get _text => _textEditingController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City Search"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: "City",
                  hintText: "Chicago",
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key("searchPage_search_iconButton"),
            onPressed: () => Navigator.of(context).pop(_text),
            icon: const Icon(
              Icons.search,
              semanticLabel: "Submit",
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
