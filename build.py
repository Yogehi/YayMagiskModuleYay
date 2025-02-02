#!/usr/bin/env python3

import requests
import os
import urllib.request
from zipfile import ZipFile

def getLastGithubRelease(yayrepoyay):
	releaseUrl = "https://api.github.com/repos/" + yayrepoyay + "/releases/latest"
	releases = requests.get(releaseUrl).json()
	return releases

# make release directory
try:
	os.mkdir("./release")
except OSError as error:
	pass

# get latest Frida release
YayFridaReleaseYay = getLastGithubRelease("frida/frida")
archs = ["arm", "arm64", "x86", "x86_64"]

# get latest Frida release tag
YayFridaReleaseTagYay = YayFridaReleaseYay["tag_name"]

# get latest Frida release .xz files
YayFridaAssetsYay = YayFridaReleaseYay["assets"]
for i1 in archs:
	# example: frida-server-16.0.19-android-arm64.xz
	YayFridaServerYay = "frida-server-" + YayFridaReleaseTagYay + "-android-" + i1 + ".xz"
	for i2 in YayFridaAssetsYay:
		if YayFridaServerYay in [i2][0]["name"]:
			YayDownloadUrlYay = [i2][0]["browser_download_url"]
			urllib.request.urlretrieve(YayDownloadUrlYay, "./files/frida-server-" + i1 + ".xz")

# if module.prop does not exist, use module.prop from module.prop.gold

YayVersionYay = ""

if os.path.isfile("module.prop") == False:
	YayGoldYay = open('module.prop.gold', 'r')
	YayPropYay = open('module.prop', 'w')

	lines = YayGoldYay.readlines()
	YayPropYay.writelines(lines)

	for line in lines:
		if "version=" in line:
			yaytempyay = line.split('=')
			YayVersionYay = yaytempyay[1].strip()

	YayGoldYay.close()
	YayPropYay.close()
# if it does exist, increase version and versioncode
else:
	YayPropYay = open('module.prop', 'r')
	lines = YayPropYay.readlines()
	YayPropYay.close()
	
	YayPropYay = open('module.prop', 'w')
	for line in lines:
		# increase version
		if "version=" in line:
			yaytempyay = line.split('=')
			yaytemp2yay = yaytempyay[1].split(".")
			line = yaytempyay[0] + "=" + str(int(yaytemp2yay[0])) + "." + str(int(yaytemp2yay[1]) + 1)
			YayVersionYay = str(int(yaytemp2yay[0])) + "." + str(int(yaytemp2yay[1]) + 1)
		if "versionCode=" in line:
			yaytempyay = line.split('=')
			line = yaytempyay[0] + "=" + str(int(yaytempyay[1].strip()) + 1)
		YayPropYay.write(line.strip())
		YayPropYay.write("\n")
	YayPropYay.close()

# zip nessecary files
with ZipFile('./release/YayPentestMagiskModuleYay-' + YayVersionYay + '.zip', 'w') as zip_object:
   # Adding files that need to be zipped
   zip_object.write('./files/frida-server-arm.xz')
   zip_object.write('./files/frida-server-arm64.xz')
   zip_object.write('./files/frida-server-x86.xz')
   zip_object.write('./files/frida-server-x86_64.xz')
   zip_object.write('./META-INF/com/google/android/update-binary')
   zip_object.write('./META-INF/com/google/android/updater-script')
   zip_object.write('./system/etc/security/cacerts/yayplaceholderyay')
   zip_object.write('./system/bin/yayplaceholderyay')
   zip_object.write('./data/local/tmp/yaytmpcayay/yayplaceholderyay')
   zip_object.write('./module.prop')
   zip_object.write('./post-fs-data.sh')
   zip_object.write('./service.sh')