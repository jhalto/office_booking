class OfficeList {
  OfficeList({
    required this.status,
    required this.message,
    required this.data,
  });
  final bool status;
  final String message;
  final Data data;

  factory OfficeList.fromJson(Map<String, dynamic> json) {
    return OfficeList(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  Data({
    required this.currentPage,
    required this.officeData, // renamed from 'data'
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });
  final int currentPage;
  final List<OfficeDetail> officeData; // List of OfficeDetail objects
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Links> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json['current_page'],
      officeData: List.from(json['data']).map((e) => OfficeDetail.fromJson(e)).toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List.from(json['links']).map((e) => Links.fromJson(e)).toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': officeData.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class OfficeDetail {
  OfficeDetail({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    // Add other relevant fields as per your API response
  });

  final int id;
  final String name;
  final String location;
  final int capacity;

  factory OfficeDetail.fromJson(Map<String, dynamic> json) {
    return OfficeDetail(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      // Map other fields here
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'capacity': capacity,
      // Add other fields here
    };
  }
}

class Links {
  Links({
    this.url,
    required this.label,
    required this.active,
  });
  final String? url;
  final String label;
  final bool active;

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
