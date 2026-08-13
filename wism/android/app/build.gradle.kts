import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Firebase (FCM) — Flutter 플러그인보다 먼저 적용
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 릴리즈 서명 정보. android/key.properties 는 git 에 올리지 않는다(비밀번호 포함).
// 이 파일과 keystore(wism-release.jks)를 잃어버리면 기존 설치본에 업데이트를 덮어쓸 수 없다.
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

android {
    namespace = "com.example.wism"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.wintek.wism"
        // 최소 Android 8.0 (API 26) — 계획서 10장
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { rootProject.file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            // key.properties 가 있으면 릴리즈 키로, 없으면 디버그 키로 서명한다.
            // (배포본은 반드시 릴리즈 키여야 함 — 키가 바뀌면 덮어쓰기 설치가 막힌다)
            signingConfig = if (keystoreProperties.getProperty("storeFile") != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
