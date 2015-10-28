#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc_prebuilt_4.8.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig psn_i9300_new_R4P0_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j3 || exit 1

mkdir -p $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/lib/modules

rm $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/lib/modules/*
rm $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT_I9300_smdk4x12_R4P0/

mv .git-halt .git
