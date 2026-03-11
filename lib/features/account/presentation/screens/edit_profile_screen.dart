import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/user_model.dart';
import '../cubit/account_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => context.pop(),
                child: AppIcons.svg(
                  'ic_arrow_back',
                  width: 14,
                  height: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 34),
              Text('Редактирование профиля', style: AppTextStyles.titleBounded),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Имя',
                controller: _nameController,
                hint: widget.user.name.isNotEmpty
                    ? widget.user.name
                    : 'Аккаунт',
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Почта',
                controller: _emailController,
                enabled: false,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    label: 'Сохранить',
                    onPressed: _save,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    try {
      await getIt<AccountCubit>().updateProfile(
        name: _nameController.text.trim(),
        login: widget.user.login,
      );
      if (mounted) context.pop(true);
    } catch (_) {
      // Ошибка уже залогирована в Talker
    }
  }
}
