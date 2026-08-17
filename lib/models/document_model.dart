enum DocumentCategory {
  fdtl,
  flight,
  crew,
  training,
  medical,
  other,
}

enum DocumentStatus {
  valid,
  pendingApproval,
  expiringSoon,
  expired,
}

/// Model representing compliance, medical, and flight operations documents.
class DocumentModel {
  final String id;
  final String title;
  final String fileName;
  final String fileFormat; // "PDF", "DOCX", etc.
  final String fileSize;   // "1.4 MB"
  final DocumentCategory category;
  final DateTime uploadDate;
  final DateTime? expiryDate;
  final DocumentStatus status;
  final String issuedBy;
  final String documentNumber;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.fileName,
    required this.fileFormat,
    required this.fileSize,
    required this.category,
    required this.uploadDate,
    this.expiryDate,
    required this.status,
    required this.issuedBy,
    required this.documentNumber,
  });

  String get categoryDisplay {
    switch (category) {
      case DocumentCategory.fdtl:
        return 'FDTL Documents';
      case DocumentCategory.flight:
        return 'Flight Documents';
      case DocumentCategory.crew:
        return 'Crew Documents';
      case DocumentCategory.training:
        return 'Training Documents';
      case DocumentCategory.medical:
        return 'Medical Documents';
      case DocumentCategory.other:
        return 'Other Documents';
    }
  }

  String get statusDisplay {
    switch (status) {
      case DocumentStatus.valid:
        return 'Valid';
      case DocumentStatus.pendingApproval:
        return 'Pending Approval';
      case DocumentStatus.expiringSoon:
        return 'Expiring Soon';
      case DocumentStatus.expired:
        return 'Expired';
    }
  }
}
