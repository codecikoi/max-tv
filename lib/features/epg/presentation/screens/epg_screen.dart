import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/epg_cubit.dart';
import '../cubit/epg_state.dart';
import '../widgets/program_tile.dart';

class EpgScreen extends StatelessWidget {
  final String channelId;

  const EpgScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EpgCubit>()..loadPrograms(channelId),
      child: _EpgView(channelId: channelId),
    );
  }
}

class _EpgView extends StatelessWidget {
  final String channelId;

  const _EpgView({required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Поиск канала',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      body: BlocBuilder<EpgCubit, EpgState>(
        builder: (context, state) {
          if (state is EpgLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EpgError) {
            return Center(child: Text(state.message));
          }
          if (state is EpgLoaded) {
            return Column(
              children: [
                // Channel header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Channel logo placeholder
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.tv, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Channel Name',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border, color: AppColors.gradientStart),
                      ),
                    ],
                  ),
                ),
                // Date selector
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: state.selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 7)),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                    );
                    if (date != null && context.mounted) {
                      context.read<EpgCubit>().changeDate(date);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d MMMM', 'ru').format(state.selectedDate),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Programs list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.programs.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      return ProgramTile(program: state.programs[index]);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
