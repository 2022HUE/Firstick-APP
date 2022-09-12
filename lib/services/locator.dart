// get_it 패키지
// global locator를 사용하여 어디에서든 type 요청 가능
// 위젯을 포장하거나 context가 없어도 사용 가능
// 따라서 전체적인 앱의 UI가 변경되더라도 올바른 서비스와 값 주입 가능
import 'package:get_it/get_it.dart';

import 'handpipe.dart';
import 'inference_service.dart';

// 전역으로 선언
final locator = GetIt.instance;

// setupLocator 함수를 생성하여 액세스하고자 하는 모든 type 등록 가능
void setupLocator() {
  // 인스턴스 등록
  // 호출할 때마다 동일한 인스턴스 반환
  // 전역으로 선언.regis~<모델> (MyModel());
  locator.registerSingleton<Handpipe>(Handpipe());
  locator.registerLazySingleton<InferenceService>(() => InferenceService());
}
