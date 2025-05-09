class VaccineApplication {
  final String vaccineName;
  final String appliedBy;
  final String pigIdentifier;
  final String pigStage;
  final DateTime applicationDate;

  VaccineApplication({
    required this.vaccineName,
    required this.appliedBy,
    required this.pigIdentifier,
    required this.pigStage,
    required this.applicationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'vaccineName': vaccineName,
      'appliedBy': appliedBy,
      'pigIdentifier': pigIdentifier,
      'pigStage': pigStage,
      'applicationDate': applicationDate.toIso8601String(),
    };
  }

  factory VaccineApplication.fromJson(Map<String, dynamic> json) {
    return VaccineApplication(
      vaccineName: json['vaccineName'],
      appliedBy: json['appliedBy'],
      pigIdentifier: json['pigIdentifier'],
      pigStage: json['pigStage'] ?? '',
      applicationDate: DateTime.parse(json['applicationDate']),
    );
  }
}