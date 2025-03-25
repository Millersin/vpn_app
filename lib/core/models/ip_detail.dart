import 'package:nerdvpn/core/models/model.dart';

class IpDetail extends Model {
  IpDetail({
    required this.yourFuckingIpAddress,
    required this.yourFuckingLocation,
    required this.yourFuckingHostname,
    required this.yourFuckingIsp,
    required this.yourFuckingTorExit,
    required this.yourFuckingCity,
    required this.yourFuckingCountry,
    required this.yourFuckingCountryCode,
  });

  String yourFuckingIpAddress;
  String yourFuckingLocation;
  String yourFuckingHostname;
  String yourFuckingIsp;
  bool yourFuckingTorExit;
  String yourFuckingCity;
  String yourFuckingCountry;
  String yourFuckingCountryCode;

  factory IpDetail.fromJson(Map<String, dynamic> json) => IpDetail(
        yourFuckingIpAddress: json["ip"] ?? "",
        yourFuckingLocation: json["region_name"] ?? "",
        yourFuckingHostname: json["hostname"] ?? "",
        yourFuckingIsp: json["asn_org"] ?? "",
        yourFuckingTorExit: false,
        yourFuckingCity: json["city"] ?? "",
        yourFuckingCountry: json["country"] ?? "",
        yourFuckingCountryCode: json["country_iso"] ?? "",
      );

  @override
  Map<String, dynamic> toJson() => {
        "YourFuckingIPAddress": yourFuckingIpAddress,
        "YourFuckingLocation": yourFuckingLocation,
        "YourFuckingHostname": yourFuckingHostname,
        "YourFuckingISP": yourFuckingIsp,
        "YourFuckingTorExit": yourFuckingTorExit,
        "YourFuckingCity": yourFuckingCity,
        "YourFuckingCountry": yourFuckingCountry,
        "YourFuckingCountryCode": yourFuckingCountryCode,
      };
}
