/////////////////////////////////////////////////////////////
///////// Model class that stores crop status data //////////
/////////////////////////////////////////////////////////////
class CropStatus {
  String? image;
  String? sproutStatus;
  String? weightLossStatus;
  String? diseaseStatus;
  String? overallHealthStatus;
  Map<String,dynamic>? shelfLifeAmbient;
  Map<String,dynamic>? shelfLifeColdStorage;

  CropStatus({
    this.image,
    this.sproutStatus,
    this.weightLossStatus,
    this.diseaseStatus,
    this.overallHealthStatus,
    this.shelfLifeColdStorage,
    this.shelfLifeAmbient,
  });
}