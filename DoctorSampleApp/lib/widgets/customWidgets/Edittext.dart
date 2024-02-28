import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Edittext extends StatefulWidget {
  Function? onChange;
  String? title = "";
  String defaultValue;
  TextInputType textInputType;
  List<TextInputFormatter>? textInputFormatter;

  Edittext({
    Key? key,
    this.title,
    this.defaultValue = "",
    this.onChange,
    this.textInputFormatter,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  State<Edittext> createState() => _EdittextState();
}

class _EdittextState extends State<Edittext> {
  final _text = TextEditingController();

  @override
  void initState() {
    _text.text = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: TextFormField(
          keyboardType: widget.textInputType,
          controller: _text,
          onChanged: (value) {
            if (widget.onChange != null) {
              widget.onChange!(value);
            }
          },

          decoration: InputDecoration(
              labelText: widget.title
          ),
          inputFormatters: widget.textInputType == TextInputType.number
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : widget.textInputFormatter,
        ));
  }
}
