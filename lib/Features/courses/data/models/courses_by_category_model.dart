class CoursesByCategoryModel {
  final List<CourseModel> items;
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;

  const CoursesByCategoryModel({
    this.items = const [],
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
  });

  factory CoursesByCategoryModel.fromApiResponse(dynamic response) {



    if (response is List) {
      return CoursesByCategoryModel(
        items: response
            .whereType<Map>()
            .map((item) => CourseModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(),
      );
    }

    if (response is Map) {
      final json = Map<String, dynamic>.from(response);
      final rawItems = json['items'] ?? json['data'] ?? json['courses'];

      if (rawItems is List) {
        return CoursesByCategoryModel(
          items: rawItems
              .whereType<Map>()
              .map((item) => CourseModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList(),
          page: _toInt(json['page']),
          pageSize: _toInt(json['pageSize']),
          totalCount: _toInt(json['totalCount']),
          totalPages: _toInt(json['totalPages']),
        );
      }
    }

    throw const FormatException('Unexpected course category response format');
  }

  factory CoursesByCategoryModel.fromJson(Map<String, dynamic> json) {
    return CoursesByCategoryModel.fromApiResponse(json);
  }

  CoursesByCategoryModel copyWith({
    List<CourseModel>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
  }) {
    return CoursesByCategoryModel(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((course) => course.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class CourseModel {
  final int? id;
  final String? slug;
  final int? teacherId;
  final String? title;
  final String? description;
  final double? price;
  final String? created;
  final double? averageRating;
  final int? watchCount;
  final List<String> tags;
  final List<String> categories;
  final String? imageUrl;

  const CourseModel({
    this.id,
    this.slug,
    this.teacherId,
    this.title,
    this.description,
    this.price,
    this.created,
    this.averageRating,
    this.watchCount,
    this.tags = const [],
    this.categories = const [],
    this.imageUrl,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: _toInt(json['id']),
      slug: json['slug']?.toString(),
      teacherId: _toInt(json['teacherId']),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      price: _toDouble(json['price']),
      created: json['created']?.toString(),
      averageRating: _toDouble(json['averageRating']),
      watchCount: _toInt(json['watchCount']),
      tags: _toStringList(json['tags']),
      categories: _toStringList(json['categories']),
      imageUrl: json['imageUrl']?.toString(),
    );
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
    };
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }
}
