import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum WebViewType { flutter_inappwebview, webview_flutter }

class WebViewScreen extends StatefulWidget {
  WebViewType webViewType;

  WebViewScreen({key, this.webViewType = WebViewType.webview_flutter});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var webUrl = "https://milindwebengage.github.io/sample_web_page/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.webViewType.name),
      ),
      body: SafeArea(
          child: widget.webViewType == WebViewType.webview_flutter
              ? webview_flutterWidget()
              : flutter_inappwebviewWidget()),
    );
  }

  Widget flutter_inappwebviewWidget() {
    return InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(webUrl),
        ),
        onWebViewCreated: (InAppWebViewController controller) async {
          controller.addJavaScriptHandler(
              handlerName: WebEngageJSBridge.jsChannelName,
              callback: (args) {
                WebEngageJSBridge.handleInAppWebViewMessage(args);
              });
        });
  }

  Widget webview_flutterWidget() {
    return WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(webUrl))
          ..addJavaScriptChannel(WebEngageJSBridge.jsChannelName,
              onMessageReceived: (JavaScriptMessage message) {
            WebEngageJSBridge.handleWebViewFlutterMessage(message.message);
          }));
  }
}
