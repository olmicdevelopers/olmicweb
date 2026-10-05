$proyecto = "$env:USERPROFILE\Proyectos\olmic_app"
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$keytool = "$env:JAVA_HOME\bin\keytool.exe"
$llave = "$env:USERPROFILE\olmic-upload.jks"
$props = "$proyecto\android\key.properties"
$gradle = "$proyecto\android\app\build.gradle.kts"

Set-Location $proyecto

if (-not (Test-Path $llave)) {
    $clave = Read-Host "Inventa una clave para la llave de Play Store (minimo 6 caracteres, GUARDALA)"
    & $keytool -genkey -v -keystore $llave -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass $clave -keypass $clave -dname "CN=Olmic Developers, O=Olmic Developers, L=Barranquilla, C=CO"
    "storePassword=$clave`nkeyPassword=$clave`nkeyAlias=upload`nstoreFile=$($llave -replace '\\','/')" | Set-Content $props
}

$g = Get-Content $gradle -Raw
if ($g -notmatch 'keystoreProperties') {
    $g = "import java.util.Properties`nimport java.io.FileInputStream`n`n" + $g
    $g = $g -replace '(?s)(plugins \{.*?\r?\n\}\r?\n)', "`$1`nval keystoreProperties = Properties()`nval keystorePropertiesFile = rootProject.file(`"key.properties`")`nif (keystorePropertiesFile.exists()) {`n    keystoreProperties.load(FileInputStream(keystorePropertiesFile))`n}`n"
    $g = $g -replace '(\n\s*)buildTypes \{', "`$1signingConfigs {`$1    create(`"release`") {`$1        keyAlias = keystoreProperties[`"keyAlias`"] as String`$1        keyPassword = keystoreProperties[`"keyPassword`"] as String`$1        storeFile = keystoreProperties[`"storeFile`"]?.let { file(it) }`$1        storePassword = keystoreProperties[`"storePassword`"] as String`$1    }`$1}`$1buildTypes {"
    $g = $g -replace 'signingConfig = signingConfigs\.getByName\("debug"\)', 'signingConfig = signingConfigs.getByName("release")'
    Set-Content $gradle $g -NoNewline
}

Write-Host "`nHuella SHA de la llave de subida (agregala en Firebase):" -ForegroundColor Cyan
$c = (Get-Content $props | Where-Object { $_ -like 'storePassword=*' }) -replace 'storePassword=',''
& $keytool -list -v -keystore $llave -alias upload -storepass $c | Select-String "SHA1:|SHA256:"

flutter clean
flutter pub get
flutter build appbundle --release

$aab = "$proyecto\build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $aab) {
    Copy-Item $aab "$env:USERPROFILE\Desktop\Olmic-1.0.0.aab" -Force
    Write-Host "`nListo: Olmic-1.0.0.aab quedo en tu Escritorio." -ForegroundColor Green
}
