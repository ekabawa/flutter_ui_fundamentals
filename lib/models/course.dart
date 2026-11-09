
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? ownerId;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'Tersedia',
    this.ownerId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String? ??
          'POST-${json['id']}',
      title: json['title'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      status: json['status'] as String? ?? 'Tersedia',
      ownerId: json['owner_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
        if (ownerId != null) 'owner_id': ownerId,
      };
}
