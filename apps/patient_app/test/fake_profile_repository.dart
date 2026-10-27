import 'package:carelink_patient/features/profile/data/profile_repository.dart';
import 'package:carelink_patient/features/profile/models/patient_profile.dart';

class FakeProfileRepository implements ProfileRepository {
  PatientProfile profile = PatientProfile.initial;
  bool failRead = false;
  bool failSave = false;

  @override
  Future<PatientProfile> read() async {
    if (failRead) throw StateError('read failed');
    return profile;
  }

  @override
  Future<void> save(PatientProfile value) async {
    if (failSave) throw StateError('save failed');
    profile = value;
  }
}
