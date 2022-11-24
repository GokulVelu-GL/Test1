class FHLSpecialRequirementModel {
  String specialRequirementSpecialCode = '';
  String specialRequirementHarmonisedCode = '';
  List<Map<String, dynamic>> specialCode = [];
  List<Map<String, dynamic>> hormoCode = [];

  clearSpecialRequirement() {
    specialRequirementSpecialCode = '';
    specialRequirementHarmonisedCode = '';
    specialCode = [];
    hormoCode = [];
  }
}
