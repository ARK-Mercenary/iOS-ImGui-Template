ARCHS = arm64

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
TARGET = iphone:clang:latest:15

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ImGuiTemplate

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Security

$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function
$(TWEAK_NAME)_CCFLAGS = -std=c++20 -fno-rtti -DNDEBUG -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -Wno-writable-strings

$(TWEAK_NAME)_FILES = ImGui/imgui_impl_metal.mm $(wildcard ImGui/*.cpp) $(wildcard Render/*.mm)

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/aggregate.mk
