








































































































































class CoursesEnrollmentModel {
  List<Items>? items;

  CoursesEnrollmentModel({this.items});

  CoursesEnrollmentModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Items {
  int? id;
  String? slug;
  int? teacherId;
  String? title;
  String? description;
  double? price;
  String? created;
  double? averageRating;
  int? watchCount;
  List<dynamic>? tags;
  List<dynamic>? categories;
  String? imageUrl;
  List<dynamic>? sections;
  String? enrolledAt;
  int? progress;
  int? totalContents;
  int? completedContents;
  bool? isCompleted;
  int? enrollmentId;
  String? status;

  Items({
    this.id,
    this.slug,
    this.teacherId,
    this.title,
    this.description,
    this.price,
    this.created,
    this.averageRating,
    this.watchCount,
    this.tags,
    this.categories,
    this.imageUrl,
    this.sections,
    this.enrolledAt,
    this.progress,
    this.totalContents,
    this.completedContents,
    this.isCompleted,
    this.enrollmentId,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    teacherId = json['teacherId'];
    title = json['title'];
    description = json['description'];
    price = (json['price']as num?)?.toDouble();
    created = json['created'];
    averageRating = (json['averageRating'] as num?)?.toDouble();
    watchCount = json['watchCount'];
    tags = json['tags'] ?? [];
    categories = json['categories'] ?? [];
    imageUrl = json['imageUrl'];
    sections = json['sections'] ?? [];
    enrolledAt = json['enrolledAt'];
    progress = json['progress'];
    totalContents = json['totalContents'];
    completedContents = json['completedContents'];
    isCompleted = json['isCompleted'];
    enrollmentId = json['enrollmentId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'price': price,
      'created': created,
      'averageRating': averageRating,
      'watchCount': watchCount,
      'tags': tags,
      'categories': categories,
      'imageUrl': imageUrl,
      'sections': sections,
      'enrolledAt': enrolledAt,
      'progress': progress,
      'totalContents': totalContents,
      'completedContents': completedContents,
      'isCompleted': isCompleted,
      'enrollmentId': enrollmentId,
      'status': status,
    };
  }
}
