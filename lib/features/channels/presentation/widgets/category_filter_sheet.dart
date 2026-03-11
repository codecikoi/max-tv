import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/channels_repository.dart';
import '../../data/repositories/favorites_repository.dart';

/// Filter type returned from the bottom sheet
class FilterResult {
  final FilterType type;
  final int? categoryId;
  final String? categoryName;

  const FilterResult({
    required this.type,
    this.categoryId,
    this.categoryName,
  });
}

enum FilterType { all, favorites, category }

/// In-memory cache for categories so we don't reload every time
class CategoryFilterCache {
  List<CategoryModel>? categories;
  int? allCount;
  int? favoritesCount;

  bool get hasData => categories != null;

  void clear() {
    categories = null;
    allCount = null;
    favoritesCount = null;
  }
}

Future<FilterResult?> showCategoryFilterSheet(
  BuildContext context, {
  FilterResult? currentFilter,
}) {
  return showModalBottomSheet<FilterResult>(
    context: context,
    backgroundColor: AppColors.surfaceLight,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    isScrollControlled: true,
    builder: (_) => _CategoryFilterSheetBody(currentFilter: currentFilter),
  );
}

class _CategoryFilterSheetBody extends StatefulWidget {
  final FilterResult? currentFilter;

  const _CategoryFilterSheetBody({this.currentFilter});

  @override
  State<_CategoryFilterSheetBody> createState() =>
      _CategoryFilterSheetBodyState();
}

class _CategoryFilterSheetBodyState extends State<_CategoryFilterSheetBody> {
  final _cache = getIt<CategoryFilterCache>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (!_cache.hasData) {
      _loading = true;
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final categoriesResult =
          await getIt<ChannelsRepository>().getCategories();
      int total = 0;
      for (final c in categoriesResult.data) {
        total += c.count;
      }

      int favCount = 0;
      try {
        final favResult = await getIt<FavoritesRepository>().getFavorites();
        favCount = favResult.meta.total;
      } catch (_) {}

      _cache.categories = categoriesResult.data;
      _cache.allCount = total;
      _cache.favoritesCount = favCount;

      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<CategoryModel> get _categories => _cache.categories ?? [];
  int get _allCount => _cache.allCount ?? 0;
  int get _favoritesCount => _cache.favoritesCount ?? 0;

  bool _isSelected(FilterType type, {int? categoryId}) {
    final current = widget.currentFilter;
    if (current == null) return type == FilterType.all;
    if (current.type != type) return false;
    if (type == FilterType.category) return current.categoryId == categoryId;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Меню',
              style: AppTextStyles.h4Mob.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'Выберите одну из категорий',
              style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
            ),
            const SizedBox(height: 12),
            if (_loading)
              _buildSkeletonList()
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildAllCell(),
                    const SizedBox(height: 2),
                    _buildFavoritesCell(),
                    ..._categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: _buildCategoryCell(cat),
                      );
                    }),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: AppLoader()),
    );
  }

  Widget _buildAllCell() {
    final selected = _isSelected(FilterType.all);
    return GestureDetector(
      onTap: () => Navigator.pop(
        context,
        const FilterResult(type: FilterType.all),
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF353333) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.surfaceLight,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _gradientText('Все телеканалы', selected: selected),
            ),
            _gradientText('$_allCount', fontSize: 12, selected: selected),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesCell() {
    final selected = _isSelected(FilterType.favorites);
    return GestureDetector(
      onTap: () => Navigator.pop(
        context,
        const FilterResult(type: FilterType.favorites),
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF353333) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.favorite, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Expanded(
              child: selected
                  ? _gradientText('Избранные', selected: true)
                  : Text(
                      'Избранные',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 20 / 16,
                        letterSpacing: -0.017 * 16,
                        color: Colors.white,
                      ),
                    ),
            ),
            Text(
              '$_favoritesCount',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 20 / 12,
                letterSpacing: -0.017 * 12,
                color: selected ? null : AppColors.bw4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCell(CategoryModel category) {
    final selected =
        _isSelected(FilterType.category, categoryId: category.id);
    return GestureDetector(
      onTap: () => Navigator.pop(
        context,
        FilterResult(
          type: FilterType.category,
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF353333) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                width: 18,
                height: 18,
                child: category.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: category.imageUrl!,
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                        color: Colors.white,
                        errorWidget: (_, _, _) => const Icon(
                          Icons.category,
                          size: 14,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.category,
                        size: 14,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: selected
                  ? _gradientText(category.name, selected: true)
                  : Text(
                      category.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 20 / 16,
                        letterSpacing: -0.017 * 16,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Text(
              '${category.count}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 20 / 12,
                letterSpacing: -0.017 * 12,
                color: selected ? null : AppColors.bw4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientText(String text,
      {double fontSize = 16, bool selected = false}) {
    if (!selected) {
      return Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          height: 20 / fontSize,
          letterSpacing: -0.017 * fontSize,
          color: Colors.white,
        ),
      );
    }
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.primaryGradient.createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          height: 20 / fontSize,
          letterSpacing: -0.017 * fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
