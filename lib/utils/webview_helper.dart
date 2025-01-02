import 'package:entryflow/base_controller.dart';
import 'package:entryflow/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewHelper {
  final BuildContext context;
  late WebViewController _controller = WebViewController();

  WebViewHelper(this.context, this._controller);

  // utility function to get TickerProvider for custom snackbar
  TickerProvider _getTickerProvider() {
    // return a valid TickerProvider from the context
    return context.findAncestorStateOfType<TickerProviderStateMixin>()!;
  }

  // odoo bga webpage-g refresh hiih
  Future<void> refreshWebView() async {
    try {
      await _controller.reload();
    } catch (e) {
      debugPrint('Error: $e');
    }
    CustomSnackBar(context).show(context, _getTickerProvider(), 'Refreshed');
  }

  // daraagiin index-d bga postruu shiljih
  Future<void> goToNext() async {
    if (BaseController.to.currentPostIndex.value <
        BaseController.to.articleLinks.length - 1) {
      // increment
      BaseController.to.currentPostIndex.value++;

      _controller.loadRequest(Uri.parse(BaseController
          .to.articleLinks[BaseController.to.currentPostIndex.value]));
    }
    CustomSnackBar(context).show(context, _getTickerProvider(), 'Next');
  }

  // umnuh index-d bga postruu shiljih
  Future<void> goToPrev() async {
    if (BaseController.to.currentPostIndex.value > 0) {
      // decrement
      BaseController.to.currentPostIndex.value--;

      _controller.loadRequest(Uri.parse(BaseController
          .to.articleLinks[BaseController.to.currentPostIndex.value]));
    }
    CustomSnackBar(context).show(context, _getTickerProvider(), 'Previous');
  }

  // odoogiin post-g share hiih
  Future<void> shareCurrentPage() async {
    try {
      final currentUrl = await _controller.currentUrl();
      if (currentUrl != null) {
        Share.share(currentUrl);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    CustomSnackBar(context).show(context, _getTickerProvider(), 'Sharing...');
  }
}
