import 'package:ElMovie/app/data/models/movie.dart';
import 'package:ElMovie/app/modules/movie_detail/controllers/movie_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailWebView extends GetView<MovieDetailController> {
  final Movie movie;

  const MovieDetailWebView({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WebView", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: WebViewWidget(
          controller: controller.webViewController(movie.imdbLink),
        ));
  }
}
