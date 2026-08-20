class CourseInfoModel {
  int? id;
  String? slug;
  int? teacherId;
  String? title;
  String? description;
  double? price;
  String? created;
  double? averageRating;
  int? watchCount;
  List<String>? tags;
  List<String>? categories;
  String? imageUrl;
  List<Sections>? sections;
  String? enrolledAt;
  int? progress;
  int? totalContents;
  int? completedContents;
  bool? isCompleted;
  int? enrollmentId;

  CourseInfoModel({
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
  });

  CourseInfoModel.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    slug = json['slug']?.toString();
    teacherId = (json['teacherId'] as num?)?.toInt();
    title = json['title']?.toString();
    description = json['description']?.toString();
    price = (json['price'] as num?)?.toDouble();
    created = json['created']?.toString();
    averageRating = (json['averageRating'] as num?)?.toDouble();
    watchCount = (json['watchCount'] as num?)?.toInt();

    tags = json['tags'] != null
        ? (json['tags'] as List).map((e) => e.toString()).toList()
        : [];

    categories = json['categories'] != null
        ? (json['categories'] as List).map((e) => e.toString()).toList()
        : [];

    imageUrl = json['imageUrl']?.toString();

    enrolledAt = json['enrolledAt']?.toString();
    progress = (json['progress'] as num?)?.toInt();
    totalContents = (json['totalContents'] as num?)?.toInt();
    completedContents = (json['completedContents'] as num?)?.toInt();
    isCompleted = json['isCompleted'] is bool ? json['isCompleted'] as bool : null;
    enrollmentId = (json['enrollmentId'] as num?)?.toInt();

    if (json['sections'] != null) {
      sections = (json['sections'] as List)
          .map((e) => Sections.fromJson(e))
          .toList();
    }
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
      'sections': sections?.map((e) => e.toJson()).toList(),
      'enrolledAt': enrolledAt,
      'progress': progress,
      'totalContents': totalContents,
      'completedContents': completedContents,
      'isCompleted': isCompleted,
      'enrollmentId': enrollmentId,
    };
  }
}

class Sections {
  int? id;
  String? title;
  String? description;
  List<Contents>? contents;

  Sections({
    this.id,
    this.title,
    this.description,
    this.contents,
  });

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']?.toString();
    description = json['description']?.toString();

    if (json['contents'] != null) {
      contents = (json['contents'] as List)
          .map((e) => Contents.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contents': contents?.map((e) => e.toJson()).toList(),
    };
  }
}

class Contents {
  int? id;
  String? title;
  String? description;
  String? url;
  String? contentType;
  int? duration;
  bool? isCompleted;
  int? lastPosition;

  Contents({
    this.id,
    this.title,
    this.description,
    this.url,
    this.contentType,
    this.duration,
    this.isCompleted,
    this.lastPosition,
  });

  Contents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']?.toString();
    description = json['description']?.toString();
    url = json['url'];
    contentType = json['contentType'];
    duration = (json['duration'] as num?)?.toInt();
    isCompleted = json['isCompleted'] is bool
        ? json['isCompleted'] as bool
        : null;
    lastPosition = (json['lastPosition'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'contentType': contentType,
      'duration': duration,
      'isCompleted': isCompleted,
      'lastPosition': lastPosition,
    };
  }
}
