import 'recommendation_service.dart';

class YogaRecommendation extends RecommendationService {
  @override
  String getRecommendation() {
    return "Try deep breathing, child pose, and cat-cow exercises.";
  }

  String getYogaLinks() {
    return "https://youtube/yoga_beginner_video";
  }
}
