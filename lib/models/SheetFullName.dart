class SheetFullName {
  final int rowNumber;
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String fullName;

  SheetFullName({
    required this.rowNumber,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.fullName,
  });

  @override
  String toString() => fullName;
}
