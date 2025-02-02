# YayPentestMagiskModuleYay
Custom Magisk Module that does various tasks on the device for pentest purposes

* Move CA certificates from the User store to the System store
    * This means you need to install your root CA via the Settings menu in Android before this module will move your root CA
* Add a `frida-server` binary to the device and run it

Latest build is in the Releases section

If you want to modify the logic of this module:

* `post-fs-data.sh` contains most of the logic, including moving root CAs for Android API 33 and below
* `service.sh` ensures `frida-server` continues to run, as well as moving root CAs for Android API 34 and above

If you want to build your own module, or if you want to build a version with newer `frida-server` binaries, then:

`python3 ./build.py`

The build script will automatically download the latest `frida-server` binaries for `arm`, `arm64`, `x86`, and `x86_64`
