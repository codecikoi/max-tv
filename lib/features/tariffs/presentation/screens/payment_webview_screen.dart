import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final String tariffName;

  const PaymentWebViewScreen({
    super.key,
    required this.url,
    required this.tariffName,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AppIcons.svg(
                        'ic_arrow_back',
                        width: 12,
                        height: 12,
                        color: AppColors.bw6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.tariffName, style: AppTextStyles.h3Mob),
                ],
              ),
            ),
            if (_isLoading)
              LinearProgressIndicator(
                color: AppColors.hovered,
                backgroundColor: AppColors.surfaceLight,
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
