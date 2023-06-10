TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
DEBUG = 0
FINALPACKAGE = 1
##THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FloatingDockXVI

$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += floatingdockxviprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
