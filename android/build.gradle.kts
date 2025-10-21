allprojects {
    repositories {
        google {
            content {
                includeGroupByRegex(".*android.*")
                includeGroupByRegex(".*google.*")
            }
        }
        mavenCentral {
            content {
                includeGroupByRegex(".*")
            }
        }
        maven {
            url = uri("https://dl.google.com/dl/android/maven2")
            isAllowInsecureProtocol = false
        }
        maven {
            url = uri("https://repo.maven.apache.org/maven2")
            isAllowInsecureProtocol = false
        }
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
            isAllowInsecureProtocol = false
        }
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
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
