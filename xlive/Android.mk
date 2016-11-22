##################################################################
# author: Richard Luo                      
# date:   2015-08-30 00:50:32
#                                                                
##################################################################

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

PATH_XYAN_CONFIGS := $(PRODUCT_OUT)/data/zb/configs
PATH_XYAN_ZBS_CONFIGS := $(PATH_XYAN_CONFIGS)/zbs
PATH_CLIPS_SOURCE := $(PRODUCT_OUT)/data/zb/clips
PATH_DEFAULT_ZB_CONFIGS := $(PRODUCT_OUT)/system/data/zb/configs
PATH_DEFAULT_CLIPS_SOURCE := $(PRODUCT_OUT)/system/data/zb/clips

$(shell mkdir -p $(PATH_XYAN_CONFIGS))
$(shell mkdir -p $(PATH_XYAN_ZBS_CONFIGS))
$(shell mkdir -p $(PATH_CLIPS_SOURCE))
$(shell mkdir -p $(PATH_DEFAULT_ZB_CONFIGS))
$(shell mkdir -p $(PATH_DEFAULT_CLIPS_SOURCE))

$(shell cp $(LOCAL_PATH)/*.clp $(PATH_CLIPS_SOURCE))
$(shell cp $(LOCAL_PATH)/scene@* $(PATH_XYAN_CONFIGS))
$(shell cp $(LOCAL_PATH)/*.clp $(PATH_DEFAULT_CLIPS_SOURCE))
$(shell cp $(LOCAL_PATH)/scene@* $(PATH_DEFAULT_ZB_CONFIGS))
