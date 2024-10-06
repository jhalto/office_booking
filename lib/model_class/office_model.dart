class OfficeModel {
  OfficeModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  OfficeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
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
    this.deletedAt,
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
    this.support,
    required this.bookings,
  });
  late final int id;
  late final String name;
  late final String type;
  late final String shortDescription;
  late final String longDescription;
  late final String location;
  late final String city;
  late final String lat;
  late final String lon;
  late final String capacity;
  late final String size;
  late final String currency;
  late final String isActive;
  late final List<int> facilityIds;
  late final List<int> menuIds;
  late final List<int> taxIds;
  late final String supportId;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;
  late final String lockLockId;
  late final String pricePerHr;
  late final String siteId;
  late final String maxDurationHr;
  late final String distance;
  late final String favouriteCount;
  late final List<Photos> photos;
  late final List<dynamic> prices;
  late final List<Facilities> facilities;
  late final List<Menus> menus;
  late final List<Taxes> taxes;
  late final Null support;
  late final List<dynamic> bookings;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
    location = json['location'];
    city = json['city'];
    lat = json['lat'];
    lon = json['lon'];
    capacity = json['capacity'];
    size = json['size'];
    currency = json['currency'];
    isActive = json['is_active'];
    facilityIds = List.castFrom<dynamic, int>(json['facility_ids']);
    menuIds = List.castFrom<dynamic, int>(json['menu_ids']);
    taxIds = List.castFrom<dynamic, int>(json['tax_ids']);
    supportId = json['support_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
    lockLockId = json['lock_lockId'];
    pricePerHr = json['price_per_hr'];
    siteId = json['site_id'];
    maxDurationHr = json['max_duration_hr'];
    distance = json['distance'];
    favouriteCount = json['favourite_count'];
    photos = List.from(json['photos']).map((e)=>Photos.fromJson(e)).toList();
    prices = List.castFrom<dynamic, dynamic>(json['prices']);
    facilities = List.from(json['facilities']).map((e)=>Facilities.fromJson(e)).toList();
    menus = List.from(json['menus']).map((e)=>Menus.fromJson(e)).toList();
    taxes = List.from(json['taxes']).map((e)=>Taxes.fromJson(e)).toList();
    support = null;
    bookings = List.castFrom<dynamic, dynamic>(json['bookings']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['short_description'] = shortDescription;
    _data['long_description'] = longDescription;
    _data['location'] = location;
    _data['city'] = city;
    _data['lat'] = lat;
    _data['lon'] = lon;
    _data['capacity'] = capacity;
    _data['size'] = size;
    _data['currency'] = currency;
    _data['is_active'] = isActive;
    _data['facility_ids'] = facilityIds;
    _data['menu_ids'] = menuIds;
    _data['tax_ids'] = taxIds;
    _data['support_id'] = supportId;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    _data['lock_lockId'] = lockLockId;
    _data['price_per_hr'] = pricePerHr;
    _data['site_id'] = siteId;
    _data['max_duration_hr'] = maxDurationHr;
    _data['distance'] = distance;
    _data['favourite_count'] = favouriteCount;
    _data['photos'] = photos.map((e)=>e.toJson()).toList();
    _data['prices'] = prices;
    _data['facilities'] = facilities.map((e)=>e.toJson()).toList();
    _data['menus'] = menus.map((e)=>e.toJson()).toList();
    _data['taxes'] = taxes.map((e)=>e.toJson()).toList();
    _data['support'] = support;
    _data['bookings'] = bookings;
    return _data;
  }
}

class Photos {
  Photos({
    required this.id,
    required this.officeId,
    required this.url,
    required this.isBanner,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String officeId;
  late final String url;
  late final String isBanner;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;

  Photos.fromJson(Map<String, dynamic> json){
    id = json['id'];
    officeId = json['office_id'];
    url = json['url'];
    isBanner = json['is_banner'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['office_id'] = officeId;
    _data['url'] = url;
    _data['is_banner'] = isBanner;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}

class Facilities {
  Facilities({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String name;
  late final String description;
  late final Null createdAt;
  late final Null updatedAt;
  late final Null deletedAt;

  Facilities.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = null;
    updatedAt = null;
    deletedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}

class Menus {
  Menus({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String name;
  late final String description;
  late final String image;
  late final Null createdAt;
  late final Null updatedAt;
  late final Null deletedAt;

  Menus.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    createdAt = null;
    updatedAt = null;
    deletedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}

class Taxes {
  Taxes({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.registrationNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String name;
  late final String type;
  late final String value;
  late final String registrationNumber;
  late final String isActive;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;

  Taxes.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    value = json['value'];
    registrationNumber = json['registration_number'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['value'] = value;
    _data['registration_number'] = registrationNumber;
    _data['is_active'] = isActive;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}