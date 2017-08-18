##################################################################
# author: Richard Luo                      
# date:   2013-03-20 15:22:08
#                                                                
##################################################################

LOCAL_PATH:= $(call my-dir)

include $(call get-mod-path, x-live)/paths.mk

common_LOCAL_C_INCLUDES := \
	$(path_zigbee) \

common_LOCAL_SHARED_LIBRARIES := \
	libXEngine \
	libLiveConsts \
	libZigbeeService \
	libutils \
	libcutils \
	liblog \

include $(CLEAR_VARS)

LOCAL_MODULE := libclips

include $(LOCAL_PATH)/sources.mk

LOCAL_C_INCLUDES := \
	$(common_LOCAL_C_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(common_LOCAL_SHARED_LIBRARIES)

LOCAL_CFLAGS += -std=c++0x

LOCAL_LDLIBS += -lrt

LOCAL_MODULE_TAGS := eng
LOCAL_PRELINK_MODULE := false

ifneq ($(TARGET_SIMULATOR),true)
LOCAL_C_INCLUDES += bionic		# very important!
LOCAL_C_INCLUDES += external/stlport/stlport 
LOCAL_SHARED_LIBRARIES += libstlport libdl
endif

include $(BUILD_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_MODULE := clips

LOCAL_SRC_FILES := main.cpp

LOCAL_C_INCLUDES := \
	$(common_LOCAL_C_INCLUDES)

LOCAL_STATIC_LIBRARIES := \
	libclips \

LOCAL_SHARED_LIBRARIES := \
	$(common_LOCAL_SHARED_LIBRARIES)

LOCAL_LDLIBS += -lrt

LOCAL_MODULE_TAGS := eng
LOCAL_PRELINK_MODULE := false

ifneq ($(TARGET_SIMULATOR),true)
LOCAL_C_INCLUDES += bionic		# very important!
LOCAL_C_INCLUDES += external/stlport/stlport 
LOCAL_SHARED_LIBRARIES += libstlport libdl
endif

include $(BUILD_EXECUTABLE)

