import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'core/network/wism_log_interceptor.dart';
import 'core/push/push_service.dart';
import 'features/onboarding/application/onboarding_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // 설치된 빌드를 확인하기 위한 최소 로그(개인정보 없음).
  WismLogInterceptor.log('앱 시작 v${AppInfo.version}');

  // 첨부 다운로드를 공용 저장소(Download/WISM)에 저장하기 위한 MediaStore 초기화.
  MediaStore.appFolder = 'WISM';
  await MediaStore.ensureInitialized();

  // 첫 실행 온보딩 여부를 동기적으로 쓸 수 있게 미리 로드(라우터 분기·깜빡임 방지).
  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool(onboardingSeenKey) ?? false;

  // Firebase 초기화 (Android: google-services.json 기반). 설정이 없으면 푸시만 비활성.
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    if (kDebugMode) debugPrint('[push] Firebase 초기화 실패(푸시 비활성): $e');
  }

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      onboardingSeenProvider.overrideWith((ref) => onboardingSeen),
    ],
    child: const WismApp(),
  ));
}
