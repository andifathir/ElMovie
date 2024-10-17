
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/movie.dart';
import '../controllers/movie_detail_controller.dart';


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
          title: const Text("WebView"),
        ),
        body: WebViewWidget(
          controller: controller.webViewController(movie.imdbLink),
        ));
  }
}