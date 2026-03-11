import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerScreen extends StatelessWidget {
  final String channelId;

  const PlayerScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Player',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
        ),
      ),
    );
  }
}
