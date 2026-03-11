import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/skeleton_program_list.dart';
import '../../../epg/data/models/program_model.dart';
import '../../../epg/data/repositories/epg_repository.dart';

class PlayerScreen extends StatefulWidget {
  final String channelId;
  final String? streamUrl;
  final String? channelName;
  final String? channelLogoUrl;
  final bool isFavourite;

  const PlayerScreen({
    super.key,
    required this.channelId,
    this.streamUrl,
    this.channelName,
    this.channelLogoUrl,
    this.isFavourite = false,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  List<ProgramModel> _programs = [];
  bool _programsLoading = true;
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _loadPrograms();
  }

  Future<void> _initPlayer() async {
    if (widget.streamUrl == null || widget.streamUrl!.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.streamUrl!),
    );

    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: true,
        showOptions: false,
        showControls: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.hovered,
          handleColor: AppColors.hovered,
          bufferedColor: AppColors.bw4,
          backgroundColor: AppColors.surfaceLight,
        ),
      );
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  String get _dateParam {
    final d = _selectedDate;
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  Future<void> _loadPrograms() async {
    try {
      final result = await getIt<EpgRepository>().getPrograms(
        int.parse(widget.channelId),
        date: _dateParam,
      );
      if (mounted) {
        setState(() {
          _programs = result.data;
          _programsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _programsLoading = false);
    }
  }

  ProgramModel? _activeProgram;

  Future<void> _switchStream(String url, {bool isLive = false}) async {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _hasError = false;
    setState(() {});

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: isLive,
        showOptions: false,
        showControls: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.hovered,
          handleColor: AppColors.hovered,
          bufferedColor: AppColors.bw4,
          backgroundColor: AppColors.surfaceLight,
        ),
      );
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onProgramTap(ProgramModel program) {
    if (program.current) {
      // Switch back to live channel stream
      if (widget.streamUrl != null && widget.streamUrl!.isNotEmpty) {
        setState(() => _activeProgram = program);
        _switchStream(widget.streamUrl!, isLive: true);
      }
    } else if (program.isArchive && program.streamUrl != null && program.streamUrl!.isNotEmpty) {
      // Switch to archive stream
      setState(() => _activeProgram = program);
      _switchStream(program.streamUrl!);
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AppIcons.svg(
                      'ic_arrow_back',
                      width: 16,
                      height: 16,
                      color: AppColors.chevron,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          AppIcons.svg(
                            'ic_search',
                            width: 24,
                            height: 24,
                            color: AppColors.iconInactive,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Поиск канала',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.iconInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _hasError
                      ? _buildErrorView()
                      : _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.hovered,
                          ),
                        ),
                ),
              ),
            ),
            _buildChannelInfo(),
            Expanded(child: _buildProgramsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 33,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [AppColors.surfaceLight, AppColors.surface],
                ),
              ),
              child: widget.channelLogoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.channelLogoUrl!,
                      width: 56,
                      height: 33,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const Icon(
                        Icons.tv,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      errorWidget: (_, _, _) => const Icon(
                        Icons.tv,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                    )
                  : const Icon(
                      Icons.tv,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.channelName ?? '',
              style: AppTextStyles.h4Mob.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.isFavourite)
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: AppIcons.svg('ic_heart', width: 16, height: 16),
            ),
        ],
      ),
    );
  }

  List<ProgramModel> get _filteredPrograms {
    var list = List<ProgramModel>.from(_programs);
    // Filter by selected date (format: DD-MM-YYYY)
    final dateStr = _dateParam;
    list = list.where((p) => p.startDate == dateStr).toList();
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((p) => p.title.toLowerCase().contains(query)).toList();
    }
    list.sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));
    return list;
  }

  bool _dateDropdownOpen = false;
  final FocusNode _searchFocusNode = FocusNode();

  List<({DateTime date, String label})> get _dateOptions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      (date: today.add(const Duration(days: 1)), label: 'Завтра'),
      (date: today, label: 'Сегодня'),
      (date: today.subtract(const Duration(days: 1)), label: 'Вчера'),
      for (int i = 2; i <= 7; i++)
        (
          date: today.subtract(Duration(days: i)),
          label: DateFormat(
            'dd MMMM',
            'ru',
          ).format(today.subtract(Duration(days: i))),
        ),
    ];
  }

  String get _formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final diff = selected.difference(today).inDays;
    if (diff == 0) return 'Сегодня';
    if (diff == 1) return 'Завтра';
    if (diff == -1) return 'Вчера';
    return DateFormat('dd MMMM', 'ru').format(_selectedDate);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _dateDropdownOpen = false;
      _programsLoading = true;
    });
    _loadPrograms();
  }

  Widget _buildProgramsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _dateDropdownOpen = !_dateDropdownOpen),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        _formattedDate,
                        style: AppTextStyles.h4Mob.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: _dateDropdownOpen ? 2 : 0,
                    child: AppIcons.svg(
                      'ic_arrow_down',
                      width: 10,
                      height: 10,
                      color: AppColors.hovered,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_dateDropdownOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _dateOptions.map((option) {
                  final isSelected =
                      DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      ) ==
                      option.date;
                  return GestureDetector(
                    onTap: () => _selectDate(option.date),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(
                        option.label,
                        style: AppTextStyles.h4Mob.copyWith(
                          color: isSelected ? Colors.white : AppColors.bw4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 4),
          // Search field
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              focusNode: _searchFocusNode,
              onTap: () {
                if (_dateDropdownOpen) {
                  setState(() => _dateDropdownOpen = false);
                }
              },
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTextStyles.bodyRegular.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Название передачи',
                hintStyle: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.bw4,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Programs list
          Expanded(
            child: _programsLoading
                ? const SkeletonProgramList()
                : _filteredPrograms.isEmpty
                ? Center(
                    child: Text(
                      'Нет программ',
                      style: AppTextStyles.captionMob.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredPrograms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      return _buildProgramTile(_filteredPrograms[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramTile(ProgramModel program) {
    final isCurrent = program.current;
    final isTappable = isCurrent || (program.isArchive && program.streamUrl != null && program.streamUrl!.isNotEmpty);
    final isActive = _activeProgram?.id == program.id;
    return GestureDetector(
      onTap: isTappable ? () => _onProgramTap(program) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (isCurrent || isActive) ? AppColors.surfaceLight : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time row + LIVE badge
            Row(
              children: [
                Text(
                  '${program.formattedStartTime ?? ''} - ${program.formattedEndTime ?? ''}',
                  style: AppTextStyles.h4Mob.copyWith(
                    color: isCurrent ? Colors.white : AppColors.bw6,
                  ),
                ),
                if (isCurrent) ...[const SizedBox(width: 12), _buildLiveBadge()],
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              program.title,
              style: AppTextStyles.captionMob.copyWith(
                color: isCurrent ? Colors.white : AppColors.bw6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (program.description != null) ...[
              const SizedBox(height: 2),
              Text(
                program.description!,
                style: AppTextStyles.captionMob.copyWith(color: AppColors.bw4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 12, top: 2, bottom: 2),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'LIVE',
            style: AppTextStyles.captionMob.copyWith(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 1.32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.svg(
              'ic_play',
              width: 48,
              height: 48,
              color: AppColors.live,
            ),
            const SizedBox(height: 8),
            const Text(
              'Не удалось загрузить',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
