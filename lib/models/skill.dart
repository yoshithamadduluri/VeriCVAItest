class Skill {
  final String id;
  final String userId;
  final String skillName;
  final String category; // Beginner, Intermediate, Advanced
  final double confidenceScore;
  final bool isVerified;
  final List<String> evidenceSources; // e.g., ["GitHub", "Certificate"]

  Skill({
    required this.id,
    required this.userId,
    required this.skillName,
    required this.category,
    required this.confidenceScore,
    required this.isVerified,
    required this.evidenceSources,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'skillName': skillName,
      'category': category,
      'confidenceScore': confidenceScore,
      'isVerified': isVerified,
      'evidenceSources': evidenceSources,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map, String id) {
    return Skill(
      id: id,
      userId: map['userId'] ?? '',
      skillName: map['skillName'] ?? '',
      category: map['category'] ?? 'Beginner',
      confidenceScore: map['confidenceScore']?.toDouble() ?? 0.0,
      isVerified: map['isVerified'] ?? false,
      evidenceSources: List<String>.from(map['evidenceSources'] ?? []),
    );
  }
}
