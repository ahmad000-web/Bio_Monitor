import 'recommendation_service.dart';

class ExerciseRecommendation extends RecommendationService {
  @override
  String getRecommendation() {
    return "Do 15 minutes of light walking and stretching daily.";
  }
}
