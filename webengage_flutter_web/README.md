# webengage_flutter_web

The web platform implementation of the [WebEngage Flutter SDK](https://github.com/WebEngage/webengage-flutter).

## Overview

This package is part of the WebEngage Flutter federated plugin architecture. It provides the web-specific implementation by bridging Dart calls to the WebEngage JavaScript SDK.

You should not need to add this package directly — it is automatically included when you add [`webengage_flutter`](https://pub.dev/packages/webengage_flutter) to your project.

## Setup

### 1. Add the WebEngage JS snippet to `web/index.html`

Add the WebEngage initialization script inside the `<head>` tag of your `web/index.html`, before the Flutter bootstrap script:

```html
<script id="_webengage_script_tag" type="text/javascript">
  var webengage;
  !function(w,e,b,n,g){function o(e,t){e[t[t.length-1]]=function(){r.__queue.push([t.join("."),arguments])}}var i,s,r=w[b],z=" ",l="init options track screen onReady".split(z),a="feedback survey notification".split(z),c="options render clear abort".split(z),p="Open Close Submit Complete View Click".split(z),u="identify login logout setAttribute".split(z);if(!r||!r.__v){for(w[b]=r={__queue:[],__v:"6.0",user:{}},i=0;i<l.length;i++)o(r,[l[i]]);for(i=0;i<a.length;i++){for(r[a[i]]={},s=0;s<c.length;s++)o(r[a[i]],[a[i],c[s]]);for(s=0;s<p.length;s++)o(r[a[i]],[a[i],"on"+p[s]])}for(i=0;i<u.length;i++)o(r.user,["user",u[i]]);setTimeout(function(){var f=e.createElement("script"),d=e.getElementById("_webengage_script_tag");f.type="text/javascript",f.async=!0,f.src=("https:"==e.location.protocol?"https://ssl.widgets.webengage.com":"http://cdn.widgets.webengage.com")+"/js/webengage-min-v-6.0.js",d.parentNode.insertBefore(f,d)})}}(window,document,"webengage");

  webengage.init('YOUR_LICENSE_CODE');
</script>
```

Replace `YOUR_LICENSE_CODE` with your WebEngage license code.

### 2. Register the service worker (for web push)

Create `web/service-worker.js`:

```js
importScripts('https://ssl.widgets.webengage.com/js/service-worker.js');
```

Register it in your `index.html`:

```html
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/service-worker.js');
  }
</script>
```

## Web-Specific APIs

The web plugin exposes additional APIs via `WebEngagePlugin.web()`:

```dart
// Wait for WebEngage JS SDK to be ready
WebEngagePlugin.web()?.onWebEngageReady(() {
  // Handle notification events
  WebEngagePlugin.web()?.handleNotificationEvent(
    WENotificationActionType.onOpen, (data) { ... });

  // Handle web push events
  WebEngagePlugin.web()?.handleWebPushEvent(
    WEWebPushEvent.onWindowAllowed, () { ... });

  // Check push support
  WebEngagePlugin.web()?.checkPushNotificationSupport((supported) { ... });

  // Set options
  WebEngagePlugin.web()?.setOption("webpush.disablePrompt", false);
});
```

## Unsupported Methods on Web

The following methods are not supported on the web platform and will log a message:
- `setUserLocation`
- `startGAIDTracking`
- `setUserDevicePushOptIn` (use web push APIs instead)
- `setUpPushCallbacks` / `setUpInAppCallbacks`
- `onPushMessageReceive` / `setPushToken`

## Requirements

- Flutter 3.22.0+
- Dart SDK 3.4.0+
- WebEngage JS SDK (loaded via script tag)

## License

See [LICENSE](LICENSE) for details.
