class HistoryPoint {
  final int id;
  final String year;
  final String description;
  final String type;

  HistoryPoint({this.id, this.year, this.description, this.type});

  //construction create Question object from json
  HistoryPoint.fromJson(Map<String, dynamic> map)
      : this.id = map['_id'],
        this.year = map['year'],
        this.description = map['description'],
        this.type = map['type'];

  @override
  String toString() {
    String output =
        "['id': $id, 'year': $year, 'description': $description, 'type': $type]";
    return output;
  }
}
