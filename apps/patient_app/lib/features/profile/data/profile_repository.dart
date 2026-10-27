import '../models/patient_profile.dart';

abstract class ProfileRepository {
  Future<PatientProfile> read();
  Future<void> save(PatientProfile profile);
}
