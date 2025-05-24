def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

// Load Flutter SDK path
def flutterSdkPath = System.getenv('FLUTTER_ROOT')
if (flutterSdkPath == null) {
    def localProperties = new Properties()
    def localPropertiesFile = new File(flutterProjectRoot.toFile(), 'local.properties')
    if (localPropertiesFile.exists()) {
        localPropertiesFile.withReader('UTF-8') { reader -> localProperties.load(reader) }
        flutterSdkPath = localProperties.getProperty('flutter.sdk')
    }
}

if (flutterSdkPath == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file or with FLUTTER_ROOT environment variable.")
}

// Load Flutter plugins
def plugins = new Properties()
def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory
}

// Apply Flutter plugin
apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle" 