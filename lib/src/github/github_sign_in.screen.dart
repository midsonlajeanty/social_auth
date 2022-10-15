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
      appBar: AppBar(
        title: const Text("github.com"),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (url)=> setState(()=> loading = false),
            navigationDelegate: (NavigationRequest request) {
              final url = Uri.parse(request.url);
              
              if (url.queryParameters['code'] != null){
                Navigator.of(context).pop(
                  url.queryParameters['code']
                );
                return NavigationDecision.prevent;
              }

              if (url.queryParameters['error'] != null){
                Navigator.of(context).pop(
                  Exception(url.queryParameters)
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