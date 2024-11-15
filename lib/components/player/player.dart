import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Player extends StatefulWidget {
  final String id;

  const Player({super.key, required this.id});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late String _id;

  WebViewController? controller;

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    if (widget.id != oldWidget.id) {
      _id = widget.id;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _id = widget.id;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            log(
              'page progress $progress',
              name: 'player',
            );
          },
          onPageStarted: (String url) {
            log(
              'page started url: $url',
              name: 'player',
            );
          },
          onPageFinished: (String url) {
            log(
              'page finished url: $url',
              name: 'player',
            );
          },
          onHttpError: (HttpResponseError error) {
            log(
              'http error',
              name: 'player',
            );
          },
          onWebResourceError: (WebResourceError error) {
            log(
              'web resource error',
              name: 'player',
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://vidsrc.to/embed/movie/$_id'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: WebViewWidget(controller: controller ?? WebViewController()));
  }
}
