plugins {
    kotlin("jvm") version "2.3.10"
    java
    antlr
    `maven-publish`
}

extra["name"] = "OCL-Kt"
extra["description"] = "OCL Kotlin impl"

group = "com.gr72s"
version = "0.1.0-SNAPSHOT"

repositories {
    mavenLocal()
    maven {
        url = uri("https://maven.aliyun.com/repository/central/")
    }
    mavenCentral()
}

dependencies {
    antlr(libs.antlr4)
    implementation(libs.antlr4.runtime)
    testImplementation(kotlin("test"))
}



java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

kotlin {
    jvmToolchain(17)
}

tasks.compileKotlin {
    dependsOn(tasks.generateGrammarSource)
}

tasks.compileTestKotlin {
    dependsOn(tasks.generateTestGrammarSource)
}

tasks.withType<JavaCompile> {
    options.encoding = "UTF-8"
}

tasks.withType<Test> {
    systemProperty("file.encoding", "UTF-8")
}

tasks.test {
    useJUnitPlatform()
    testLogging {
        events("passed", "skipped", "failed")
        showStandardStreams = true
    }
}

tasks.generateGrammarSource<AntlrTask> {
    val pkg = "com.gr72s"
    val targetSourceDir = file("src/main/antlr/.antlr")
    with(arguments) {
        addAll(listOf("-package", pkg,"-no-listener"))
    }

    doLast {
        copy {
            from(outputDirectory)
            into(targetSourceDir)
            include("**/Lexical.tokens")
            include("**/Lexical.interp")
        }
    }
}


