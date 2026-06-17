class Resume {
  final String id;
  final String userId;
  final String fileUrl;
  final String fileName;
  final double? atsScore;
  final double? trustScore;
  final Map<String, dynamic>? analysisReport;
  final DateTime uploadedAt;

  Resume({
    required this.id,
    required this.userId,
    required this.fileUrl,
    required this.fileName,
    this.atsScore,
    this.trustScore,
    this.analysisReport,
    required this.uploadedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'atsScore': atsScore,
      'trustScore': trustScore,
      'analysisReport': analysisReport,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory Resume.fromMap(Map<String, dynamic> map, String id) {
    return Resume(
      id: id,
      userId: map['userId'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileName: map['fileName'] ?? '',
      atsScore: map['atsScore']?.toDouble(),
      trustScore: map['trustScore']?.toDouble(),
      analysisReport: map['analysisReport'],
      uploadedAt: DateTime.parse(map['uploadedAt']),
    );
  }
}
