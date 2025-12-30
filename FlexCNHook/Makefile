TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlexCNHook

FlexCNHook_FILES = Sources/FlexCNHook.m
FlexCNHook_CFLAGS = -fobjc-arc -I./Sources
# FlexCNHook_LIBRARIES = hooker

include $(THEOS_MAKE_PATH)/tweak.mk
