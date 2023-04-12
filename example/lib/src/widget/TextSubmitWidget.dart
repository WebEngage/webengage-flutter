import 'package:flutter/material.dart';

class TextSubmitWidget extends StatefulWidget {
  Function? submit;
  String title;

  TextSubmitWidget({Key? key, this.submit, this.title = "title"})
      : super(key: key);

  @override
  State<TextSubmitWidget> createState() => _TextSubmitWidgetState();
}

class _TextSubmitWidgetState extends State<TextSubmitWidget> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: widget.title,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
            onPressed: () {
              if (widget.submit != null &&
                  textEditingController.text.isNotEmpty) {
                widget.submit!(textEditingController.text);
              }
            },
            child: Text("${widget.title}"))
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
