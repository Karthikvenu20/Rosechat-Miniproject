// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal() // ✅ Ensures Kotlin dependencies are resolved
    }
}

// ✅ Define new build directory path
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// ✅ Ensure subprojects use the new build directory
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ✅ Ensure ":app" project is evaluated first
subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Clean task to delete the new build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
