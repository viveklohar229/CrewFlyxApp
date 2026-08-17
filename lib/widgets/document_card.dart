import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';

/// Document item card with file type, status, expiry, and download/view action buttons.
class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const DocumentCard({
    super.key,
    required this.document,
    this.onView,
    this.onDownload,
  });

  BadgeType _mapStatusToBadge(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.valid:
        return BadgeType.valid;
      case DocumentStatus.pendingApproval:
        return BadgeType.pending;
      case DocumentStatus.expiringSoon:
        return BadgeType.expiringSoon;
      case DocumentStatus.expired:
        return BadgeType.expired;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PDF / Document Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySky.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.primarySky,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),

              // Title and category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.aeroNavy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${document.categoryDisplay} • ${document.fileSize}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: document.statusDisplay,
                type: _mapStatusToBadge(document.status),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Metadata Row & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doc #: ${document.documentNumber}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                    ),
                  ),
                  if (document.expiryDate != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Expires: ${DateFormatter.formatShortDate(document.expiryDate!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warningOrange,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 20),
                    color: AppColors.primarySky,
                    tooltip: 'View Document',
                    onPressed: onView,
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    color: AppColors.primarySky,
                    tooltip: 'Download',
                    onPressed: onDownload,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
