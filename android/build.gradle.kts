allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    project.evaluationDependsOn(":app")

    // Force SDK 36 for all Android modules (app and plugins)
    // This uses the official "withId" listener which is safe for EVALUATION lifecycle
    plugins.withId("com.android.application") {
        configureAndroidSDK(project)
    }
    plugins.withId("com.android.library") {
        configureAndroidSDK(project)
    }
}

fun configureAndroidSDK(project: Project) {
    val android = project.extensions.findByName("android")
    if (android != null) {
        // Use property access for compatibility across Kotlin DSL versions
        try {
            val setCompileSdk = android::class.java.getMethod("setCompileSdk", Int::class.javaPrimitiveType)
            setCompileSdk.invoke(android, 36)
        } catch (e: Exception) {
            // Fallback for older versions if necessary
            try {
                val compileSdkVersion = android::class.java.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                compileSdkVersion.invoke(android, 36)
            } catch (e2: Exception) {}
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
