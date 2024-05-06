String formatName(String name) {
  final String fullName = name;
  final List<String> nameParts = fullName.split(' ');
  final String firstName = nameParts[0];
  final String format = firstName.substring(0, 1).toUpperCase() +
      firstName.substring(1).toLowerCase();

  return format;
}
