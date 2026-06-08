class HubEvent {
  final String id;
  final String title;
  final String description;
  final String category;
  final String type;
  final String location;
  final String date;
  final String time;
  final String price;
  final bool isOnline;
  final String status;
  final String tags;
  final String imageUrl;
  final bool isFeatured;
  final String createdAt;

  HubEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.isOnline,
    required this.status,
    required this.tags,
    required this.imageUrl,
    required this.isFeatured,
    required this.createdAt,
  });

  factory HubEvent.fromJson(Map<String, dynamic> json) {
    return HubEvent(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      isOnline: json['isOnline'] == true,
      status: json['status']?.toString() ?? '',
      tags: json['tags']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      isFeatured: json['isFeatured'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  bool get isFree {
    final normalized = price.toLowerCase();
    return price.isEmpty ||
        normalized.contains('free') ||
        normalized.contains('مجاني');
  }
}

class HubJob {
  final String id;
  final String title;
  final String description;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String status;
  final String createdAt;
  final String updatedAt;

  HubJob({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HubJob.fromJson(Map<String, dynamic> json) {
    return HubJob(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class HubTraining {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String location;
  final String startDate;
  final String endDate;
  final int? capacity;
  final String price;
  final String status;
  final String createdAt;
  final String updatedAt;

  HubTraining({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.capacity,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HubTraining.fromJson(Map<String, dynamic> json) {
    return HubTraining(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      instructor: json['instructor']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      capacity: json['capacity'] is int
          ? json['capacity'] as int
          : int.tryParse(json['capacity']?.toString() ?? ''),
      price: json['price']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
