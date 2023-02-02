Navegación con MapBox:
Para utilizar MapBox es necesario instalar el SDK en la app con las credenciales necesarias.
Documentación:
https://docs.mapbox.com/android/maps/guides/install/

Configuración en el gradle

buildscript {
    ext.kotlin_version = '1.6.10'
    repositories {
        google()
        mavenCentral()
        maven {
            url 'https://api.mapbox.com/downloads/v2/releases/maven'
            authentication {
                basic(BasicAuthentication)
            }
            credentials {
                username = 'mapbox'
                password = MAPBOX_DOWNLOADS_TOKEN
            }
        }
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.8'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

task clean(type: Delete) {
    delete rootProject.buildDir
}


gradle.properties

org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
MAPBOX_DOWNLOADS_TOKEN=sk.eyJ1IjoiZW5lcm1heCIsImEiOiJjbGRtZWxxZGMwNjhsM3ZwaHh2M2doY2FhIn0.vooTPcc7b-w1KIB0X7fSJg