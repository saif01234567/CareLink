class PatientProfile {
  const PatientProfile({required this.displayName});
  final String displayName;

  static const initial = PatientProfile(displayName: 'Amina');
  static const demoId = 'CL-DEMO-024';

  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter a demo name.';
    if (name.runes.length > 60) return 'Use 60 characters or fewer.';
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(name)) {
      return 'Use a name without line breaks or control characters.';
    }
    return null;
  }
}
