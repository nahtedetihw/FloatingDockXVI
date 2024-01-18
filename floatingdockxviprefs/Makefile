TARGET := iphone:clang:14.5:14.5

include $(THEOS)/makefiles/common.mk

SYSROOT=$(THEOS)/sdks/iPhoneOS14.5.sdk

#THEOS_PACKAGE_SCHEME=rootless

BUNDLE_NAME = floatingdockxviprefs

$(BUNDLE_NAME)_FILES = FDXVIPreferences.m
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations
$(BUNDLE_NAME)_LDFLAGS = -ld_classic

include $(THEOS_MAKE_PATH)/bundle.mk
