import 'package:entryflow/theme/colors.dart'; // theme specific colors
import 'package:entryflow/utils/webview_helper.dart'; // controls for webview
import 'package:entryflow/widgets/custom_floating_button.dart'; // reusable floating button widget
import 'package:flutter/material.dart';

class WebviewButtons extends StatelessWidget {
  final WebViewHelper webViewHelper;

  const WebviewButtons({
    super.key,
    required this.webViewHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Column(
        spacing: 10,
        children: [
          CustomFloatingButton(
            onPressed: webViewHelper.goToNext,
            toolTip: 'Next',
            foregroundColor:
                AppColors.nextButtonColor(Theme.of(context).brightness),
            icon: Icons.arrow_upward_rounded,
          ),
          CustomFloatingButton(
            onPressed: webViewHelper.goToPrev,
            toolTip: 'Previous',
            foregroundColor:
                AppColors.prevButtonColor(Theme.of(context).brightness),
            icon: Icons.arrow_downward_rounded,
          ),
          CustomFloatingButton(
            onPressed: webViewHelper.refreshWebView,
            toolTip: 'Refresh',
            foregroundColor:
                AppColors.refreshButtonColor(Theme.of(context).brightness),
            icon: Icons.refresh_rounded,
          ),
          CustomFloatingButton(
            onPressed: webViewHelper.shareCurrentPage,
            toolTip: 'Share',
            foregroundColor:
                AppColors.shareButtonColor(Theme.of(context).brightness),
            icon: Icons.share_rounded,
            iconSize: 26,
          ),
        ],
      ),
    );
  }
}
