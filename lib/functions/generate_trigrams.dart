List<String> generateTrigram(String input) {
  if (input.length < 3) {
    return [];
  }

  // Create trigrams
  List<String> trigrams = [];
  for (int i = 0; i < input.length - 2; i++) {
    trigrams.add(input.substring(i, i + 3).toLowerCase());
  }

  return trigrams;
}
