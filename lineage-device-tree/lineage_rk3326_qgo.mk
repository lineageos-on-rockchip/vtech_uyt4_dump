#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from rk3326_qgo device
$(call inherit-product, device/rockchip/rk3326_qgo/device.mk)

PRODUCT_DEVICE := rk3326_qgo
PRODUCT_NAME := lineage_rk3326_qgo
PRODUCT_BRAND := rockchip
PRODUCT_MODEL := rk3326_qgo
PRODUCT_MANUFACTURER := rockchip

PRODUCT_GMS_CLIENTID_BASE := android-rockchip

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="rk3326_qgo-user 10 QD4A.200805.003 eng.epicbu.20231228.113918 release-keys"

BUILD_FINGERPRINT := rockchip/rk3326_qgo/rk3326_qgo:10/QD4A.200805.003/epicbuilder212281139:user/release-keys
