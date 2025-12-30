TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlexCNHook

FlexCNHook_FILES = Sources/FlexCNHook.m
FlexCNHook_CFLAGS = -fobjc-arc -I./Sources
# FlexCNHook_LIBRARIES = hooker

include $(THEOS_MAKE_PATH)/tweak.mk
