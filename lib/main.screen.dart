import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:file_saver/file_saver.dart';

class InAppWebViewMainScreen extends StatefulWidget {
  @override
  _InAppWebViewMainScreenState createState() =>
      new _InAppWebViewMainScreenState();
}

class _InAppWebViewMainScreenState extends State<InAppWebViewMainScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnDownloadStart: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          // webViewController?.reload();
        } else if (Platform.isIOS) {
          // webViewController?.loadUrl(
          //    urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: avoid_void_async
  void _createFileFromBase64(
      String base64content, String fileName, String fileExt) async {
    var bytes = base64Decode(base64content.replaceAll('\n', ''));
    await FileSaver.instance.saveFile(fileName, bytes, fileExt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              // contextMenu: contextMenu,
              //initialFile: "assets/index.html",
              initialUrlRequest:
                  // URLRequest(url: Uri.parse("http://192.168.137.6/")),
                  URLRequest(url: Uri.parse("http://10.10.100.254/")),
              // URLRequest(
              //     url: Uri.parse(
              //         "https://novax.netlify.app/products/intellicross")),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: "blobToBase64Handler",
                  callback: (data) async {
                    if (data.isNotEmpty) {
                      final String receivedFileInBase64 = data[0].toString();
                      //final String receivedMimeType = data[1];
                      // NOTE: create a method that will handle your extensions
                      final String file_ext = 'inc';
                      _createFileFromBase64(
                          receivedFileInBase64, 'intellicross', file_ext);
                    }
                  },
                );
              },
              onLoadStart: (controller, url) {
                // FlutterNativeSplash.remove();
                setState(() {
                  this.url = url.toString();
                });
              },

              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }

                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              onDownloadStart: (controller, url) async {
                print("onDownloadStart $url");
                var jsContent =
                    await rootBundle.loadString("assets/js/base64.js");
                await controller.evaluateJavascript(
                    source: jsContent.replaceAll(
                        "blobUrlPlaceholder", url.toString()));
              },
            ),
            //  progress < 1.0
            //      ? LinearProgressIndicator(value: progress)
            //      : Container(),
          ],
        ),
      ),
    ])));
  }
}
