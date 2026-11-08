# IncogniaBypass Tweak Makefile

MODULE_NAME = IncogniaBypass

TWEAK_NAME = IncogniaBypass
DISPLAY_NAME = Incognia Bypass for Revolut

IncogniaBypass_FILES = IncogniaBypass.xm
IncogniaBypass_CFLAGS = -fobjc-arc -DTHEOS_DEVICE_SILENT=0
IncogniaBypass_IPHONEOS_DEPLOYMENT_TARGET = 12.0
IncogniaBypass_ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IncogniaBypass
include $(THEOS_MAKE_PATH)/tweak.mk

# Bundle for Revolut
TARGET = iphone:clang:16.0

after-install::
	install.exec "killall -u com.revolut.revolut"
