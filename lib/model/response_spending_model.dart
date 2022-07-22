import 'dart:convert';

class ResponseSpending {
  ResponseSpending({
    required this.metadata,
    required this.data,
  });

  final Metadata metadata;
  final List<Datum> data;

  factory ResponseSpending.fromRawJson(String str) => ResponseSpending.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseSpending.fromJson(Map<String, dynamic> json) => ResponseSpending(
        metadata: Metadata.fromJson(json["metadata"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.nominal,
    required this.createdDate,
    required this.updatedDate,
  });

  final String id;
  final String userId;
  final String name;
  final String description;
  final int nominal;
  final DateTime createdDate;
  final DateTime updatedDate;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        nominal: json["nominal"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "nominal": nominal,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
      };
}

class Metadata {
  Metadata({
    required this.httpCode,
    required this.page,
    required this.limit,
  });

  final int httpCode;
  final int page;
  final int limit;

  factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        httpCode: json["http_code"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "http_code": httpCode,
        "page": page,
        "limit": limit,
      };
}
