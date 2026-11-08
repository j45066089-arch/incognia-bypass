# IncogniaBypass Tweak Makefile

MODULE_NAME = incogniabypass

TWEAK_NAME = incogniabypass
DISPLAY_NAME = Incognia Bypass for Revolut

incogniabypass_FILES = IncogniaBypass.xm
incogniabypass_CFLAGS = -fobjc-arc -DTHEOS_DEVICE_SILENT=0
incogniabypass_IPHONEOS_DEPLOYMENT_TARGET = 12.0
incogniabypass_ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = incogniabypass
include $(THEOS_MAKE_PATH)/tweak.mk

# Bundle for Revolut
TARGET = iphone:clang:15.6

after-install::
	install.exec "killall -u com.revolut.revolut"
