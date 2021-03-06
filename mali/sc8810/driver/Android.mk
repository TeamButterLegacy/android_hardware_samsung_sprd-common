LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := ump.ko
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/modules
LOCAL_SRC_FILES := ump/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := mali.ko
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/modules
LOCAL_SRC_FILES := mali/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

ifeq ($(TARGET_BUILD_VARIANT),user)
  DEBUGMODE := BUILD=no
else
  DEBUGMODE := $(DEBUGMODE)
endif

$(LOCAL_PATH)/ump/ump.ko: bootimage
	$(MAKE) -C $(shell dirname $@) CONFIG=$(TARGET_BOARD_PLATFORM) $(DEBUGMODE) KDIR=$(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ clean
	$(MAKE) -C $(shell dirname $@) CONFIG=$(TARGET_BOARD_PLATFORM) $(DEBUGMODE) KDIR=$(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(shell dirname $@)/ump.ko

$(LOCAL_PATH)/mali/mali.ko: $(LOCAL_PATH)/ump/ump.ko
	$(MAKE) -C $(shell dirname $@) MALI_PLATFORM=$(TARGET_BOARD_PLATFORM) $(DEBUGMODE) KDIR=$(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ clean
	$(MAKE) -C $(shell dirname $@) MALI_PLATFORM=$(TARGET_BOARD_PLATFORM) $(DEBUGMODE) KDIR=$(ANDROID_PRODUCT_OUT)/obj/KERNEL_OBJ
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(shell dirname $@)/mali.ko
