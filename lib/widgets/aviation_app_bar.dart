import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../state/app_state_provider.dart';
import 'aviation_logo.dart';

/// Aviation app bar header containing brand logo, search bar, notification badge, and menu button.
class AviationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final String title;
  final bool isRoot;

  const AviationAppBar({
    super.key,
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.onSearchClear,
    this.title = 'Crew Flyx',
    this.isRoot = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 120 : 64);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = AppStateScope.of(context);
    final unreadCount = state.unreadNotificationCount;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          if (!isRoot)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: isDark ? Colors.white : AppColors.aeroNavy,
              onPressed: () => Navigator.of(context).maybePop(),
            )
          else ...[
            const AviationLogo(size: 34),
            const SizedBox(width: 10),
            Text(
              'Crew Flyx',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: isDark ? Colors.white : AppColors.aeroNavy,
              ),
            ),
          ],
          if (!isRoot)
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.aeroNavy,
              ),
            ),
        ],
      ),
      actions: [
        // Notification Icon with unread badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 24),
              color: isDark ? Colors.white : AppColors.aeroNavy,
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.of(context).pushNamed('/notifications');
              },
            ),
            if (unreadCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.emergencyRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const Size(18, 18),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Hamburger / Drawer Menu Icon
        Builder(
          builder: (scaffoldContext) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded, size: 26),
              color: isDark ? Colors.white : AppColors.aeroNavy,
              tooltip: 'Open Menu',
              onPressed: () {
                Scaffold.of(scaffoldContext).openDrawer();
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: showSearch
          ? PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _SearchBar(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: onSearchClear,
                  isDark: isDark,
                ),
              ),
            )
          : null,
    );
  }
}

class _SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool isDark;

  const _SearchBar({
    this.controller,
    this.onChanged,
    this.onClear,
    required this.isDark,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 46,
      decoration: BoxDecoration(
        color: widget.isDark
            ? AppColors.aeroNavyMedium
            : (_isFocused ? Colors.white : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isFocused
              ? AppColors.primarySky
              : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          width: _isFocused ? 1.8 : 1.0,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primarySky.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 14,
          color: widget.isDark ? Colors.white : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: widget.isDark ? AppColors.textMuted : AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.primarySky,
          ),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: widget.isDark ? AppColors.textMuted : AppColors.textSecondary,
                  onPressed: () {
                    _textController.clear();
                    if (widget.onChanged != null) widget.onChanged!('');
                    if (widget.onClear != null) widget.onClear!();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
