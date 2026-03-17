import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.template.monorepo.exam.dev"
            resValue(type = "string", name = "app_name", value = "Dev: Module App")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.template.monorepo.exam"
            resValue(type = "string", name = "app_name", value = "Module App")
        }
    }
}