##################################################################
# author: Richard Luo                      
# date:   2015-08-30 00:50:32
#                                                                
##################################################################

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

PATH_CLIPS_SOURCE := $(PRODUCT_OUT)/data/xlive/vds/clips
PATH_DEFAULT_CLIPS_SOURCE := $(PRODUCT_OUT)/system/data/xlive/vds/clips

$(shell mkdir -p $(PATH_CLIPS_SOURCE))
$(shell mkdir -p $(PATH_DEFAULT_CLIPS_SOURCE))

$(shell cp $(LOCAL_PATH)/*.clp $(PATH_CLIPS_SOURCE))
$(shell cp $(LOCAL_PATH)/*.clp $(PATH_DEFAULT_CLIPS_SOURCE))
