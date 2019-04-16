##################################################################
# author: Richard Luo                      
# date:   2015-07-02 16:57:24
#                                                                
##################################################################

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := clips_test1

LOCAL_SRC_FILES := clips_test1.cpp

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../

LOCAL_SHARED_LIBRARIES := \
	libXEngine \
	libZigbeeService \
	libLiveConsts \
	libutils \
	libcutils \
	libbinder \
	liblog \


LOCAL_PRELINK_MODULE := false

LOCAL_MODULE_TAGS := eng

LOCAL_STATIC_LIBRARIES := \
	libclips \


ifneq ($(TARGET_SIMULATOR),true)
LOCAL_C_INCLUDES += bionic		# very important!
LOCAL_C_INCLUDES += external/stlport/stlport 
LOCAL_SHARED_LIBRARIES += libstlport libdl
endif

include $(BUILD_EXECUTABLE)
