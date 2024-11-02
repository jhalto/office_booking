class OfficeModel2 {
  OfficeModel2({
    required this.status,
    required this.data,
  });

  final bool? status;
  final Data? data;

  factory OfficeModel2.fromJson(Map<String, dynamic> json){
    return OfficeModel2(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.unreadNotificationCount,
    required this.unreadChatMessageCount,
    required this.nearestOffices,
  });

  final int? unreadNotificationCount;
  final int? unreadChatMessageCount;
  final List<NearestOffice> nearestOffices;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      unreadNotificationCount: json["unread_notification_count"],
      unreadChatMessageCount: json["unread_chat_message_count"],
      nearestOffices: json["nearest offices"] == null ? [] : List<NearestOffice>.from(json["nearest offices"]!.map((x) => NearestOffice.fromJson(x))),
    );
  }

}

class NearestOffice {
  NearestOffice({
    required this.id,
    required this.name,
    required this.type,
    required this.shortDescription,
    required this.longDescription,
    required this.location,
    required this.city,
    required this.lat,
    required this.lon,
    required this.capacity,
    required this.size,
    required this.currency,
    required this.isActive,
    required this.facilityIds,
    required this.menuIds,
    required this.taxIds,
    required this.supportId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.lockLockId,
    required this.pricePerHr,
    required this.siteId,
    required this.maxDurationHr,
    required this.distance,
    required this.favouriteCount,
    required this.photos,
    required this.prices,
    required this.facilities,
    required this.menus,
    required this.taxes,
    required this.support,
  });

  final int? id;
  final String? name;
  final String? type;
  final String? shortDescription;
  final String? longDescription;
  final String? location;
  final String? city;
  final String? lat;
  final String? lon;
  final String? capacity;
  final String? size;
  final String? currency;
  final String? isActive;
  final List<int> facilityIds;
  final List<int> menuIds;
  final List<int> taxIds;
  final String? supportId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? lockLockId;
  final String? pricePerHr;
  final String? siteId;
  final String? maxDurationHr;
  final String? distance;
  final String? favouriteCount;
  final List<Photo> photos;
  final List<dynamic> prices;
  final List<Facility> facilities;
  final List<Facility> menus;
  final List<Tax> taxes;
  final dynamic support;

  factory NearestOffice.fromJson(Map<String, dynamic> json){
    return NearestOffice(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      shortDescription: json["short_description"],
      longDescription: json["long_description"],
      location: json["location"],
      city: json["city"],
      lat: json["lat"],
      lon: json["lon"],
      capacity: json["capacity"],
      size: json["size"],
      currency: json["currency"],
      isActive: json["is_active"],
      facilityIds: json["facility_ids"] == null ? [] : List<int>.from(json["facility_ids"]!.map((x) => x)),
      menuIds: json["menu_ids"] == null ? [] : List<int>.from(json["menu_ids"]!.map((x) => x)),
      taxIds: json["tax_ids"] == null ? [] : List<int>.from(json["tax_ids"]!.map((x) => x)),
      supportId: json["support_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      lockLockId: json["lock_lockId"],
      pricePerHr: json["price_per_hr"],
      siteId: json["site_id"],
      maxDurationHr: json["max_duration_hr"],
      distance: json["distance"],
      favouriteCount: json["favourite_count"],
      photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      prices: json["prices"] == null ? [] : List<dynamic>.from(json["prices"]!.map((x) => x)),
      facilities: json["facilities"] == null ? [] : List<Facility>.from(json["facilities"]!.map((x) => Facility.fromJson(x))),
      menus: json["menus"] == null ? [] : List<Facility>.from(json["menus"]!.map((x) => Facility.fromJson(x))),
      taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
      support: json["support"],
    );
  }

}

class Facility {
  Facility({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.image,
  });

  final int? id;
  final String? name;
  final String? description;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final String? image;

  factory Facility.fromJson(Map<String, dynamic> json){
    return Facility(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      image: json["image"],
    );
  }

}

class Photo {
  Photo({
    required this.id,
    required this.officeId,
    required this.url,
    required this.isBanner,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? officeId;
  final String? url;
  final String? isBanner;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      id: json["id"],
      officeId: json["office_id"],
      url: json["url"],
      isBanner: json["is_banner"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}

class Tax {
  Tax({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.registrationNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? name;
  final String? type;
  final String? value;
  final String? registrationNumber;
  final String? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Tax.fromJson(Map<String, dynamic> json){
    return Tax(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      value: json["value"],
      registrationNumber: json["registration_number"],
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

}
