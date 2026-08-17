import '../models/document_model.dart';
import '../mock_data/mock_data.dart';

/// Service for managing aviation documents, categorization, and digital sign-offs.
class DocumentService {
  final List<DocumentModel> _documents = List.from(MockData.documents);

  Future<List<DocumentModel>> getDocuments({DocumentCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == null) return List.unmodifiable(_documents);
    return _documents.where((doc) => doc.category == category).toList();
  }

  Future<List<DocumentModel>> searchDocuments(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.trim().isEmpty) return _documents;
    final lower = query.toLowerCase();
    return _documents.where((d) =>
      d.title.toLowerCase().contains(lower) ||
      d.fileName.toLowerCase().contains(lower) ||
      d.issuedBy.toLowerCase().contains(lower) ||
      d.documentNumber.toLowerCase().contains(lower)
    ).toList();
  }
}
