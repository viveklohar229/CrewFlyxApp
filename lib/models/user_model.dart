/// Model representing the authenticated crew member.
class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String employeeId;
  final String designation; // e.g. "Senior Captain", "First Officer", "Lead Cabin Attendant"
  final String companyName;
  final String companyCode;
  final String baseAirport; // e.g. "DEL / VIDP"
  final String licenseNumber; // e.g. "ATPL-84920"
  final String licenseExpiry;
  final String medicalExpiry;
  final String email;
  final String phone;
  final int totalFlightHours;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.employeeId,
    required this.designation,
    required this.companyName,
    required this.companyCode,
    required this.baseAirport,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.medicalExpiry,
    required this.email,
    required this.phone,
    required this.totalFlightHours,
    required this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? employeeId,
    String? designation,
    String? companyName,
    String? companyCode,
    String? baseAirport,
    String? licenseNumber,
    String? licenseExpiry,
    String? medicalExpiry,
    String? email,
    String? phone,
    int? totalFlightHours,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      employeeId: employeeId ?? this.employeeId,
      designation: designation ?? this.designation,
      companyName: companyName ?? this.companyName,
      companyCode: companyCode ?? this.companyCode,
      baseAirport: baseAirport ?? this.baseAirport,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      medicalExpiry: medicalExpiry ?? this.medicalExpiry,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      totalFlightHours: totalFlightHours ?? this.totalFlightHours,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'employeeId': employeeId,
    'designation': designation,
    'companyName': companyName,
    'companyCode': companyCode,
    'baseAirport': baseAirport,
    'licenseNumber': licenseNumber,
    'licenseExpiry': licenseExpiry,
    'medicalExpiry': medicalExpiry,
    'email': email,
    'phone': phone,
    'totalFlightHours': totalFlightHours,
    'avatarUrl': avatarUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    username: json['username'] as String,
    fullName: json['fullName'] as String,
    employeeId: json['employeeId'] as String,
    designation: json['designation'] as String,
    companyName: json['companyName'] as String,
    companyCode: json['companyCode'] as String,
    baseAirport: json['baseAirport'] as String,
    licenseNumber: json['licenseNumber'] as String,
    licenseExpiry: json['licenseExpiry'] as String,
    medicalExpiry: json['medicalExpiry'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    totalFlightHours: json['totalFlightHours'] as int,
    avatarUrl: json['avatarUrl'] as String,
  );
}
