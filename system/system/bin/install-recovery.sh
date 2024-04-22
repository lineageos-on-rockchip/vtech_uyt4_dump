#!/system/bin/sh
if ! applypatch --check EMMC:/dev/block/by-name/recovery:58652672:e4416f6bb942b043118459b857ba80f677067d6e; then
  applypatch  \
          --patch /system/recovery-from-boot.p \
          --source EMMC:/dev/block/by-name/boot:32407552:9f753409d5321fbf900592d2e27e640a9ab21d5f \
          --target EMMC:/dev/block/by-name/recovery:58652672:e4416f6bb942b043118459b857ba80f677067d6e && \
      log -t recovery "Installing new recovery image: succeeded" || \
      log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
