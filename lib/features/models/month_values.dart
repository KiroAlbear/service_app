class MonthServiceValues {
  final String firstName;
  final String fatherName;
  final String grandfatherName;

  final int morningService; // قداس
  final int communion; // تناول
  final int service; // اجتماع
  final int confession; // اعتراف

  MonthServiceValues({
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.morningService,
    required this.communion,
    required this.service,
    required this.confession,
  });

  @override
  String toString() {
    return 'MonthServiceValues('
        'firstName: $firstName, '
        'fatherName: $fatherName, '
        'grandfatherName: $grandfatherName, '
        'morningService: $morningService, '
        'communion: $communion, '
        'service: $service, '
        'confession: $confession'
        ')';
  }
}

class MonthServiceColumns {
  final int morningServiceIndex;
  final int communionIndex;
  final int serviceIndex;
  final int confessionIndex;

  const MonthServiceColumns({
    required this.morningServiceIndex,
    required this.communionIndex,
    required this.serviceIndex,
    required this.confessionIndex,
  });
}
