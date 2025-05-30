import java.util.Properties

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    resolutionStrategy {
        eachPlugin {
            if (requested.id.id == "com.android.application") {
                useVersion("8.3.0")
            }
        }
    }

    plugins {
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
        id("com.android.application") version "8.3.0" apply false
        id("org.jetbrains.kotlin.android") version "1.9.10" apply false
        id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "android"
include(":app")

// Flutter configuration
val flutterProjectRoot = rootProject.projectDir.parentFile
val plugins = File(flutterProjectRoot, ".flutter-plugins")
if (plugins.exists()) {
    plugins.readLines().forEach { line ->
        if (line.isNotEmpty() && !line.startsWith("#")) {
            val (name, path) = line.split("=")
            include(":$name")
            project(":$name").projectDir = File(path)
        }
    }
}
