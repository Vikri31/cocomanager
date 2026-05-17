// 1. Letakkan import ini di PALING ATAS file build.gradle
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 2. Letakkan logika pemuatan file setelah blok plugins
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // JANGAN PAKAI CONTOH TUTORIAL, gunakan ID dari dosenmu di sini:
    namespace = "com.ti24a3.app13"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // WAJIB gunakan ID aplikasi dari dosenmu:
        applicationId = "com.ti24a3.app13"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 3. TAMBAHKAN / PASANG BLOK SIGNING CONFIGS INI
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // Memastikan build tipe release dikunci menggunakan keystore di atas
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}