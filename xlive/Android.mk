##################################################################
# author: Richard Luo                      
# date:   2015-08-30 00:50:32
#                                                                
##################################################################

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

PATH_ZB_CONFIGS := $(PRODUCT_OUT)/root/zb/configs
PATH_CLIPS_SOURCE := $(PRODUCT_OUT)/root/zb/clips

$(shell mkdir -p $(PATH_CLIPS_SOURCE))
$(shell cp $(LOCAL_PATH)/*.clp $(PATH_CLIPS_SOURCE))
$(shell cp $(LOCAL_PATH)/scene@* $(PATH_ZB_CONFIGS))

