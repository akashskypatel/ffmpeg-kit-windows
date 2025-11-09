#!/bin/sh

./cross_compile_ffmpeg_progress.sh \
  --sandbox-ok=y \
  --compiler-flavors=win64 \
  --build-ffmpeg-static=y \
  --build-ffmpeg-shared=y \
  --enable-gpl=y \
  --disable-nonfree=n \
  --git-get-latest=n \
  --build-mplayer=n \
  --build-mp4box=n \
  --build-vlc=n

#   --build-dependencies=n \
#   --enable-gpl=y  \
#   --enable-version3 \
#   --disable-nonfree=n  \
#   --prefer-stable=n  \
#   --build-ffmpeg-static=y  \
#   --fdk-aac-git-checkout-version=v2.0.1  \
#   --compiler-flavors=win64 \
#   --disable-neon \
#   --enable-asm \
#   --enable-inline-asm \
#   --disable-autodetect \
#   --enable-cross-compile \
#   --enable-pic \
#   --enable-optimizations \
#   --enable-swscale \
#   --enable-small \
#   --enable-pthreads \
#   --disable-static --enable-shared \
#   --disable-v4l2-m2m \
#   --disable-outdev=fbdev \
#   --disable-indev=fbdev \
#   --disable-alsa \
#   --disable-appkit \
#   --disable-audiotoolbox \
#   --disable-chromaprint \
#   --disable-cuda \
#   --disable-cuvid \
#   --disable-debug --enable-lto \
#   --disable-doc \
#   --disable-gmp \
#   --disable-gnutls \
#   --disable-htmlpages \
#   --disable-iconv \
#   --disable-libaom \
#   --disable-libass \
#   --disable-libdav1d \
#   --disable-libfontconfig \
#   --disable-libfreetype \
#   --disable-libfribidi \
#   --disable-libilbc \
#   --disable-libkvazaar \
#   --enable-libmp3lame \
#   --disable-libopencore-amrnb \
#   --disable-libopenh264 \
#   --enable-libopus \
#   --disable-librubberband \
#   --disable-libshine \
#   --disable-libsnappy \
#   --disable-libsoxr \
#   --disable-libspeex \
#   --disable-libsrt \
#   --disable-libtesseract \
#   --disable-libtheora \
#   --disable-libtwolame \
#   --disable-libvidstab \
#   --disable-libvo-amrwbenc \
#   --disable-libvorbis \
#   --disable-libvpx \
#   --disable-libwebp \
#   --enable-libx264 \
#   --disable-libx265 \
#   --disable-libxml2 \
#   --disable-libxvid \
#   --disable-libzimg \
#   --disable-manpages \
#   --disable-neon-clobber-test \
#   --disable-nvenc \
#   --disable-openssl \
#   --disable-podpages \
#   --disable-postproc \
#   --disable-programs \
#   --disable-schannel \
#   --disable-sdl2 \
#   --disable-securetransport \
#   --disable-sndio \
#   --disable-txtpages \
#   --disable-vaapi \
#   --disable-vdpau \
#   --disable-videotoolbox \
#   --disable-xlib \
#   --disable-xmm-clobber-test \
#   --enable-zlib


  







































