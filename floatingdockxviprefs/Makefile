ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT=$(THEOS)/sdks/iPhoneOS14.2.sdk

BUNDLE_NAME = floatingdockxviprefs
$(BUNDLE_NAME)_FILES = FDXVIPreferencesListController.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences OnBoardingKit
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
$(BUNDLE_NAME)_CFLAGS = -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/floatingdockxviprefs.plist$(ECHO_END)
