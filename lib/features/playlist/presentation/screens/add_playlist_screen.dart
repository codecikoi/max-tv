import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/playlist_cubit.dart';
import '../cubit/playlist_state.dart';
import '../widgets/playlist_help_sheet.dart';

const _playlistShownKey = 'playlist_screen_shown';

class AddPlaylistScreen extends StatelessWidget {
  const AddPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlaylistCubit>(),
      child: const _AddPlaylistBody(),
    );
  }
}

class _AddPlaylistBody extends StatefulWidget {
  const _AddPlaylistBody();

  @override
  State<_AddPlaylistBody> createState() => _AddPlaylistBodyState();
}

class _AddPlaylistBodyState extends State<_AddPlaylistBody> {
  final _controller = TextEditingController();
  bool _hasText = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final url = _controller.text.trim();
    if (url.isEmpty) return;
    context.read<PlaylistCubit>().validatePlaylistUrl(url);
  }

  Future<void> _markShownAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_playlistShownKey, true);
    if (mounted) context.go('/channels');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<PlaylistCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistValidated) {
              _markShownAndNavigate();
            }
            if (state is PlaylistError) {
              _controller.clear();
              setState(() => _errorMessage = state.message);
              Future.delayed(const Duration(milliseconds: 700), () {
                if (mounted) setState(() => _errorMessage = null);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Spacer(),
                AppImages.png('img_playlist', width: 240),
                const SizedBox(height: 24),
                Text(
                  'Добавьте свой плейлист',
                  style: AppTextStyles.h3Mob,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Вставьте ссылку на ваш плейлист, чтобы начать просмотр',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.bw6,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                BlocBuilder<PlaylistCubit, PlaylistState>(
                  buildWhen: (prev, curr) =>
                      curr is PlaylistInitial ||
                      curr is PlaylistError ||
                      curr is PlaylistValidating,
                  builder: (context, state) {
                    return AppTextField(
                      controller: _controller,
                      hint: 'Введите ссылку',
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      onChanged: (_) {
                        if (state is PlaylistError) {
                          context.read<PlaylistCubit>().resetState();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => showPlaylistHelpSheet(context),
                  child: Text(
                    'Как получить ссылку?',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: AppColors.pink,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                BlocBuilder<PlaylistCubit, PlaylistState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (state is PlaylistValidating)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: AppLoader(),
                          )
                        else if (_errorMessage != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcons.svg('ic_error', width: 20, height: 20),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTextStyles.captionSmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ] else
                          const SizedBox(height: 36),
                        Opacity(
                          opacity: _hasText ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: !_hasText,
                            child: AppButton.primary(
                              label: 'Подтвердить',
                              width: double.infinity,
                              onPressed: _submit,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> isPlaylistScreenShown() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_playlistShownKey) ?? false;
}
