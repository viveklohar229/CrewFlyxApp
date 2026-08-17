import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/document_card.dart';
import '../../widgets/empty_state_view.dart';

/// Documents screen categorized by FDTL, Flight, Crew, Training, and Medical compliance.
class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<DocumentCategory?> _categories = [
    null, // All
    DocumentCategory.fdtl,
    DocumentCategory.flight,
    DocumentCategory.crew,
    DocumentCategory.training,
    DocumentCategory.medical,
    DocumentCategory.other,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AviationAppBar(
        title: 'Compliance Documents',
        showSearch: true,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        onSearchClear: () => setState(() => _searchQuery = ''),
      ),
      drawer: const AviationDrawer(activeIndex: 4),
      body: Column(
        children: [
          // Category Tab Bar
          Container(
            color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.5) : AppColors.surfaceLight,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primarySky,
              unselectedLabelColor: isDark ? AppColors.textMuted : AppColors.textSecondary,
              indicatorColor: AppColors.primarySky,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(text: 'All Documents'),
                Tab(text: 'FDTL'),
                Tab(text: 'Flight Docs'),
                Tab(text: 'Crew / License'),
                Tab(text: 'Training'),
                Tab(text: 'Medical'),
                Tab(text: 'Other'),
              ],
            ),
          ),

          // Tab Bar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final filtered = state.documents.where((doc) {
                  final matchesCat = category == null || doc.category == category;
                  final matchesQuery = _searchQuery.isEmpty ||
                      doc.title.toLowerCase().contains(_searchQuery) ||
                      doc.fileName.toLowerCase().contains(_searchQuery) ||
                      doc.issuedBy.toLowerCase().contains(_searchQuery) ||
                      doc.documentNumber.toLowerCase().contains(_searchQuery);

                  return matchesCat && matchesQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyStateView(
                    title: 'No Documents Found',
                    message: 'No documents in this category matching your search.',
                    icon: Icons.folder_off_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    return DocumentCard(
                      document: doc,
                      onView: () => _showDocumentViewerDialog(context, doc),
                      onDownload: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading ${doc.fileName}...'),
                            backgroundColor: AppColors.primarySky,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentViewerDialog(BuildContext context, DocumentModel doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: AppColors.emergencyRed),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                doc.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File: ${doc.fileName} (${doc.fileSize})'),
            const SizedBox(height: 6),
            Text('Document Number: ${doc.documentNumber}'),
            const SizedBox(height: 6),
            Text('Issued By: ${doc.issuedBy}'),
            const SizedBox(height: 6),
            Text('Status: ${doc.statusDisplay}'),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.skyBackground.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primarySky.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, color: AppColors.primarySky, size: 36),
                    SizedBox(height: 6),
                    Text(
                      'Official Flight Operations Document',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primarySkyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySky,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download PDF'),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloaded ${doc.fileName} successfully.'),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
