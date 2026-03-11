import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/account_repository.dart';
import 'change_password_screen.dart';
import 'pin_success_screen.dart';
import 'reset_pin_screen.dart';
import 'set_pin_screen.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel user;

  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repo = getIt<AccountRepository>();
  late bool _allowNsfw;
  late bool _hasNsfwPin;
  bool _togglingNsfw = false;

  @override
  void initState() {
    super.initState();
    _allowNsfw = widget.user.allowNsfw;
    _hasNsfwPin = widget.user.hasNsfwPin;
  }

  Future<void> _onToggleNsfw(bool value) async {
    setState(() {
      _allowNsfw = value;
      _togglingNsfw = true;
    });
    try {
      await _repo.toggleNsfw();
    } catch (_) {
      if (mounted) setState(() => _allowNsfw = !value);
    } finally {
      if (mounted) setState(() => _togglingNsfw = false);
    }
  }

  void _showSetPinOverlay() {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => const SetPinScreen(),
          ),
        )
        .then((result) {
          if (result == true && mounted) {
            setState(() => _hasNsfwPin = true);
            _showPinSuccess('ПИН-код установлен');
          }
        });
  }

  void _showResetPinOverlay() {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) =>
                ResetPinScreen(onChangePassword: _showChangePasswordOverlay),
          ),
        )
        .then((result) {
          if (result == true && mounted) {
            setState(() => _hasNsfwPin = false);
            _showPinSuccess(
              'ПИН-код сброшен',
              subtitle: 'Вы можете установить новый\nкод-пароль в настройках',
            );
          }
        });
  }

  void _showPinSuccess(String title, {String? subtitle}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            PinSuccessScreen(title: title, subtitle: subtitle),
      ),
    );
  }

  void _onPinTap() {
    if (_hasNsfwPin) {
      _showResetPinOverlay();
    } else {
      _showSetPinOverlay();
    }
  }

  void _showChangePasswordOverlay() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            ChangePasswordScreen(email: widget.user.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
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
            ),
            const SizedBox(height: 20),
            Text('Настройки', style: AppTextStyles.titleBounded),
            const SizedBox(height: 16),
            _buildSectionHeader(
              title: 'ПИН-код',
              subtitle: 'Защищает от перехода к контенту 18+',
            ),
            const SizedBox(height: 20),
            _buildCard(
              children: [
                _buildToggleRow(
                  title: 'Показывать контент 18+',
                  value: _allowNsfw,
                  loading: _togglingNsfw,
                  onChanged: _onToggleNsfw,
                ),
                const SizedBox(height: 32),
                _buildNavRow(
                  title: _hasNsfwPin
                      ? 'Сбросить пин-код'
                      : 'Установить пин-код',
                  onTap: _onPinTap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(
              title: 'Безопасность',
              subtitle: 'Настройка данных от аккаунта',
            ),
            const SizedBox(height: 20),
            _buildCard(
              children: [
                _buildInfoRow(title: 'Почта', value: widget.user.email),
                const SizedBox(height: 32),
                _buildNavRow(
                  title: 'Сменить пароль',
                  onTap: () => _showChangePasswordOverlay(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3Mob),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceLight, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool loading = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h4Mob),
        GestureDetector(
          onTap: loading ? null : () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 24,
            decoration: BoxDecoration(
              color: value ? null : AppColors.surfaceLight,
              gradient: value ? AppColors.primaryGradient : null,
              borderRadius: BorderRadius.circular(30),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: value ? Colors.white : AppColors.bw4,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h4Mob),
        Text(
          value,
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.bw6,
            letterSpacing: -0.14,
          ),
        ),
      ],
    );
  }

  Widget _buildNavRow({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h4Mob),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null) ...[trailing],
              AppIcons.svg(
                'ic_arrow_right',
                width: 12,
                height: 12,
                color: AppColors.hovered,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
