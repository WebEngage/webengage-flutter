class CellData {
  final String title;
  final String description;
  final String experimentId;
  String status;
  final Map<String, dynamic> inboxMessage;

  CellData(
      {required this.title,
      required this.description,
      required this.experimentId,
      required this.status,
      required this.inboxMessage});
}
