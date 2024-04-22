#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# API levels
PRODUCT_SHIPPING_API_LEVEL := 29

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := tablet

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh \

PRODUCT_PACKAGES += \
    fstab.rk30board \
    init.connectivity.rc \
    init.mount_all.rc \
    init.optee.rc \
    init.rk30board.bootmode.emmc.rc \
    init.rk30board.bootmode.nvme.rc \
    init.rk30board.bootmode.unknown.rc \
    init.rk30board.environment.rc \
    init.rk30board.rc \
    init.rk30board.usb.rc \
    init.rk3326.rc \
    init.rk3326.usb.rc \
    init.rockchip.rc \
    init.rc \
    init.recovery.rk30board.rc \
    ueventd.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.rk30board:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/rockchip/rk3326_qgo/rk3326_qgo-vendor.mk)
