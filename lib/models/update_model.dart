class Update {
  final String version;
  final String releaseTimestamp;
  final String availableOnPlayStore;
  final dynamic changelogEn;
  final dynamic changelogPt;

  Update({
    required this.version,
    required this.releaseTimestamp,
    required this.availableOnPlayStore,
    required this.changelogEn,
    required this.changelogPt,
  });

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      version: json["version"],
      releaseTimestamp: json["release_timestamp"],
      availableOnPlayStore: json["available_on_playstore"],
      changelogEn: json["changelog_en"],
      changelogPt: json["changelog_pt"],
    );
  }
}
