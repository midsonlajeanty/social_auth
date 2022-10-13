import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GithubSignInScreen extends StatefulWidget {
  const GithubSignInScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<GithubSignInScreen> createState() => _GithubSignInScreenState();
}

class _GithubSignInScreenState extends State<GithubSignInScreen> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool loading = true;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            backgroundColor: Theme.of(context).backgroundColor,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (url)=> setState(()=> loading = false),
            navigationDelegate: (NavigationRequest request) {
              if (Uri.parse(request.url).queryParameters['code'] != null){
                Navigator.of(context).pop(
                  Uri.parse(request.url).queryParameters['code']
                );
                return NavigationDecision.prevent;
              }
              if (Uri.parse(request.url).queryParameters['error'] != null){
                Navigator.of(context).pop(
                  Exception(Uri.parse(request.url).queryParameters['error_description'])
                );
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          Visibility(
            visible: loading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      )
    );
  }
}