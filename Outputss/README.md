.apk
'- name: Curl Upload IPA
      uses: wei/curl@v1
      with:
        args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@rooster/build/ios/iphoneos/${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.ipa
    - name: Curl Upload APP
      uses: wei/curl@v1
      with: 
        args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@rooster/build/ios/iphoneos/${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.app
    '

    - name: Upload iPA
      uses: actions/upload-artifact@master
      with:
        name: ios-build
        path: Outputss/${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.ipa
    - name: Upload iPAs
      uses: actions/upload-artifact@master
      with:
        name: ios-build
        path: Outputss/${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.app




          build_ios:
    name: Build Flutter (iOS)
    runs-on: macOS-latest
    steps:
    - uses: actions/checkout@v1
    - uses: actions/setup-java@v1
      with:
        java-version: '12.x'
    - uses: subosito/flutter-action@v1
      with:
          channel: 'dev'
    - run: flutter pub get
    - run: flutter clean
    - run: flutter build ios --release --no-codesign
    - uses: papeloto/action-zip@v1
      with:
        files: rooster/build/ios/iphoneos
        dest: rooster/Outputss/result.zip
    - name: Upload iPA
      uses: actions/upload-artifact@master
      with:
        name: ios-build
        path: rooster/Outputss
  uploadfile:
    name: upload
    runs-on: ubuntu-latest
    if: always()
    needs: [build, build_ios]
    steps:
      - name: Checkout repository
        uses: actions/checkout@v1
      - name: set up JDK 1.8
        uses: actions/setup-java@v1
        with:
          java-version: 1.8
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: apk-build
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: ios-build
      - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.apk
      - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@$result.zip






          old file:

          name: Dart CI

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

defaults:
  run:
    working-directory: "rooster"

jobs:
  build:
    name: Build Apps
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v1
      - name: Set up Java
        uses: actions/setup-java@v1
        with:
          java-version: "12.x"
      - name: Set up Flutter
        uses: subosito/flutter-action@v1
        with:
          channel: "stable"
      - name: Install pub Dependencies
        run: flutter pub get
      - name: Build Android App
        run: flutter build apk --split-per-abi
      - name: Rename file
        run: mv build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk build/app/outputs/flutter-apk/${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.apk
      - name: Upload APK
        uses: actions/upload-artifact@master
        with:
          name: apk-build
          path: rooster/build/app/outputs/flutter-apk/
  build_ios:
    name: Build Flutter (iOS)
    runs-on: macOS-latest
    steps:
    - uses: actions/checkout@v1
    - uses: actions/setup-java@v1
      with:
        java-version: '12.x'
    - uses: subosito/flutter-action@v1
      with:
          channel: 'dev'
    - run: flutter pub get
    - run: flutter clean
    - run: flutter build ios --release --no-codesign
    - uses: papeloto/action-zip@v1
      with:
        files: rooster/build/ios/iphoneos
        dest: rooster/Outputss/result.zip
    - name: Upload iPA
      uses: actions/upload-artifact@master
      with:
        name: ios-build
        path: rooster/Outputss
  uploadfile:
    name: upload
    runs-on: ubuntu-latest
    if: always()
    needs: [build, build_ios]
    steps:
      - name: Checkout repository
        uses: actions/checkout@v1
      - name: set up JDK 1.8
        uses: actions/setup-java@v1
        with:
          java-version: 1.8
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: apk-build
      - name: Download Artifact
        uses: actions/download-artifact@master
        with:
          name: ios-build
      - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.apk
      - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@$result.zip


          removed - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.apk
      




            - name: Curl Upload APK
        uses: wei/curl@v1
        with:
          args: --location --request POST  https://roostertech6.herokuapp.com/uploader --form file=@${{ github.event.repository.name }}_${{github.event_name}}_${{github.actor}}.apk