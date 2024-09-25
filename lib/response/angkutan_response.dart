import 'package:moda/model/angkutan_model.dart';

class AngkutanResponse {
  final int currentPage;
  final List<AngkutanModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  AngkutanResponse({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory AngkutanResponse.fromJson(Map<String, dynamic> json) {
    List<AngkutanModel> dataList = [];
    if (json['data'] != null) {
      List<dynamic> list = json['data'].cast<dynamic>();
      dataList = list.map((i) => AngkutanModel.fromJson(i)).toList();
    }

    var linkList = json['links'] as List? ?? [];
    List<Link> linkDataList = linkList.map((i) => Link.fromJson(i)).toList();

    return AngkutanResponse(
      currentPage: json['current_page'] ?? 0,
      data: dataList,
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      lastPageUrl: json['last_page_url'] ?? '',
      links: linkDataList,
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
