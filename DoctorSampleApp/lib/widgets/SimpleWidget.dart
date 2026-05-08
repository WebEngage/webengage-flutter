import 'package:flutter/material.dart';
import '../WEUtils/AppColor.dart';
import 'package:dev_sample_app/WEUtils/ScreenNavigator.dart';

enum WidgetType { none, image, text, mixed }

class SimpleWidget extends StatefulWidget {
  WidgetType widgetType;
  int index;

  SimpleWidget({Key? key, this.widgetType = WidgetType.none, this.index = 0})
      : super(key: key);

  @override
  State<SimpleWidget> createState() => _SimpleWidgetState();
}

class _SimpleWidgetState extends State<SimpleWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  var viewHeight = 70.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    switch (widget.widgetType) {
      case WidgetType.image:
        return InkWell(
            onTap: () {
              ScreenNavigator.gotoDetailScreen(context);
            },
            child: image());
      case WidgetType.text:
        return text();
      default:
        return baseWidget(Container());
    }
  }

  Widget cont(Color color) {
    return Container(
      height: 200,
      width: 400,
      color: color,
    );
  }

  Widget image() => baseWidget(
        Image.network(
            fit: BoxFit.cover,
            'https://t4.ftcdn.net/jpg/04/95/28/65/240_F_495286577_rpsT2Shmr6g81hOhGXALhxWOfx1vOQBa.jpg'),
      );

  Widget text() => baseWidget(Text(
        "The default Image.network constructor doesn’t handle more advanced functionality, such as fading images in after loading, or caching images to the device after they’re downloaded. To accomplish these tasks, see the following recipes:",
        style: TextStyle(),
      ));

  Widget baseWidget(Widget _widget) => Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        //height: viewHeight,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Text(
              "${widget.index}",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(child: _widget),
          ],
        ),
      );
}
