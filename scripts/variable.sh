#!/bin/bash

export MINGW_W64_BRANCH="master"
export BINUTILS_BRANCH="binutils-2_44-branch"
export GCC_BRANCH="releases/gcc-14"

export top_dir=$(pwd)
export sandbox="prebuilt"
export cur_dir="$top_dir/$sandbox"
export patch_dir="$top_dir/patches"
export cpu_count="$(grep -c processor /proc/cpuinfo 2>/dev/null)" # linux cpu count

# variables with their defaults
export build_ffmpeg_static=y
export build_ffmpeg_shared=n
export build_dvbtee=n
export build_libmxf=n
export build_mp4box=n
export build_mplayer=n
export build_vlc=n
export build_lsw=n # To build x264 with L-Smash-Works.
export build_dependencies=y
export git_get_latest=y
export prefer_stable=y # Only for x264 and x265.
export build_intel_qsv=y # libvpl 
export build_amd_amf=y
export disable_nonfree=y # comment out to force user y/n selection
export original_cflags='-mtune=generic -O3 -pipe' # high compatible by default, see #219, some other good options are listed below, or you could use -march=native to target your local box:
export original_cppflags='-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3' # Needed for mingw-w64 7 as FORTIFY_SOURCE is now partially implemented, but not actually working
# if you specify a march it needs to first so x264's configure will use it :| [ is that still the case ?]
# original_cflags='-march=znver2 -O3 -pipe'
#flags=$(cat /proc/cpuinfo | grep flags)
#if [[ $flags =~ "ssse3" ]]; then # See https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html, https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html and https://stackoverflow.com/questions/19689014/gcc-difference-between-o3-and-os.
#  original_cflags='-march=core2 -O2'
#elif [[ $flags =~ "sse3" ]]; then
#  original_cflags='-march=prescott -O2'
#elif [[ $flags =~ "sse2" ]]; then
#  original_cflags='-march=pentium4 -O2'
#elif [[ $flags =~ "sse" ]]; then
#  original_cflags='-march=pentium3 -O2 -mfpmath=sse -msse'
#else
#  original_cflags='-mtune=generic -O2'
#fi
export ffmpeg_git_checkout_version=
export build_ismindex=n
export enable_gpl=y
export build_x264_with_libav=n # To build x264 with Libavformat.
export ffmpeg_git_checkout="https://github.com/FFmpeg/FFmpeg.git"
export ffmpeg_source_dir=
export build_svt_hevc=n
export build_svt_vp9=n
export build_dependencies_only=n

export original_cpu_count=$cpu_count # save it away for some that revert it temporarily

export PKG_CONFIG_LIBDIR= # disable pkg-config from finding [and using] normal linux system installed libs [yikes]
export original_path="$PATH"


export BUILD_STEPS=(
  "check_native"
  "build_libdavs2"
  "check_host_target"
  "build_meson_cross"
  "build_mingw_std_threads"
  "build_zlib"
  "build_libcaca"
  "build_bzip2"
  "build_liblzma"
  "build_iconv"
  "build_sdl2"  
  "check_gpulibs"
  "build_nv_headers"
  "build_libzimg"
  "build_libopenjpeg"
  "build_glew"
  "build_glfw"
  "build_libpng"
  "build_libwebp"
  "build_libxml2"
  "build_brotli"
  "build_harfbuzz"
  "build_libvmaf"
  "build_fontconfig"
  "build_gmp"  
  "build_libnettle"
  "build_unistring"
  "build_libidn2"
  "build_zstd"
  "build_gnutls"
  "build_curl"
  "build_libogg"
  "build_libvorbis"
  "build_libopus"
  "build_libspeexdsp"
  "build_libspeex"
  "build_libtheora"
  "check_build_libsndfile"
  "build_mpg123"
  "build_lame"
  "build_twolame"
  "build_openmpt"
  "build_libopencore"
  "build_libilbc"
  "build_libmodplug"
  "build_libgme"
  "build_libbluray"
  "build_libbs2b"
  "build_libsoxr"
  "build_libflite"
  "build_libsnappy"
  "build_vamp_plugin"
  "build_fftw"
  "build_libsamplerate"
  "build_librubberband"
  "build_frei0r"  
  "check_svt"
  "build_vidstab"
  "build_libmysofa"  
  "check_audiotoolbox"
  "build_zvbi"
  "build_fribidi"
  "build_libass"
  "build_libxvid"
  "build_libsrt"
  "check_libaribcaption"
  "build_libaribb24"
  "build_libtesseract"
  "build_lensfun"
  "check_libtensorflow"
  "build_libvpx"
  "build_libx265"
  "build_libopenh264"
  "build_libaom"
  "build_dav1d"
  "check_vulkan_libplacebo"
  "build_avisynth"
  "build_libvvenc"
  "build_libvvdec"
  "build_libx264"
  "build_apps"
)

while true; do
  case $1 in
    -top_dir | --top_dir) echo "$top_dir" ; shift;;
    -sandbox | --sandbox) echo "$sandbox" ; shift;;
    -cur_dir | --cur_dir) echo "$cur_dir" ; shift;;
    -patch_dir | --patch_dir) echo "$patch_dir" ; shift;;
    -cpu_count | --cpu_count) echo "$cpu_count" ; shift;;
    -build_ffmpeg_static | --build_ffmpeg_static) echo "$build_ffmpeg_static" ; shift;;
    -build_ffmpeg_shared | --build_ffmpeg_shared) echo "$build_ffmpeg_shared" ; shift;;
    -build_dvbtee | --build_dvbtee) echo "$build_dvbtee" ; shift;;
    -build_libmxf | --build_libmxf) echo "$build_libmxf" ; shift;;
    -build_mp4box | --build_mp4box) echo "$build_mp4box" ; shift;;
    -build_mplayer | --build_mplayer) echo "$build_mplayer" ; shift;;
    -build_vlc | --build_vlc) echo "$build_vlc" ; shift;;
    -build_lsw | --build_lsw) echo "$build_lsw" ; shift;;
    -build_dependencies | --build_dependencies) echo "$build_dependencies" ; shift;;
    -git_get_latest | --git_get_latest) echo "$git_get_latest" ; shift;;
    -prefer_stable | --prefer_stable) echo "$prefer_stable" ; shift;;
    -build_intel_qsv | --build_intel_qsv) echo "$build_intel_qsv" ; shift;;
    -build_amd_amf | --build_amd_amf) echo "$build_amd_amf" ; shift;;
    -disable_nonfree | --disable_nonfree) echo "$disable_nonfree" ; shift;;
    -original_cflags | --original_cflags) echo "$original_cflags" ; shift;;
    -original_cppflags | --original_cppflags) echo "$original_cppflags" ; shift;;
    -ffmpeg_git_checkout_version | --ffmpeg_git_checkout_version) echo "$ffmpeg_git_checkout_version" ; shift;;
    -build_ismindex | --build_ismindex) echo "$build_ismindex" ; shift;;
    -enable_gpl | --enable_gpl) echo "$enable_gpl" ; shift;;
    -build_x264_with_libav | --build_x264_with_libav) echo "$build_x264_with_libav" ; shift;;
    -ffmpeg_git_checkout | --ffmpeg_git_checkout) echo "$ffmpeg_git_checkout" ; shift;;
    -ffmpeg_source_dir | --ffmpeg_source_dir) echo "$ffmpeg_source_dir" ; shift;;
    -build_svt_hevc | --build_svt_hevc) echo "$build_svt_hevc" ; shift;;
    -build_svt_vp9 | --build_svt_vp9) echo "$build_svt_vp9" ; shift;;
    -build_dependencies_only | --build_dependencies_only) echo "$build_dependencies_only" ; shift;;
    -original_cpu_count | --original_cpu_count) echo "$original_cpu_count" ; shift;;
    -a | --all) 
    echo -e "top_dir=$top_dir\n" \
            "sandbox=$sandbox\n" \
            "cur_dir=$cur_dir\n" \
            "patch_dir=$patch_dir\n" \
            "cpu_count=$cpu_count\n" \
            "build_ffmpeg_static=$build_ffmpeg_static\n" \
            "build_ffmpeg_shared=$build_ffmpeg_shared\n" \
            "build_dvbtee=$build_dvbtee\n" \
            "build_libmxf=$build_libmxf\n" \
            "build_mp4box=$build_mp4box\n" \
            "build_mplayer=$build_mplayer\n" \
            "build_vlc=$build_vlc\n" \
            "build_lsw=$build_lsw\n" \
            "build_dependencies=$build_dependencies\n" \
            "git_get_latest=$git_get_latest\n" \
            "prefer_stable=$prefer_stable\n" \
            "build_intel_qsv=$build_intel_qsv\n" \
            "build_amd_amf=$build_amd_amf\n" \
            "disable_nonfree=$disable_nonfree\n" \
            "original_cflags=$original_cflags\n" \
            "original_cppflags=$original_cppflags\n" \
            "ffmpeg_git_checkout_version=$ffmpeg_git_checkout_version\n" \
            "build_ismindex=$build_ismindex\n" \
            "enable_gpl=$enable_gpl\n" \
            "build_x264_with_libav=$build_x264_with_libav\n" \
            "ffmpeg_git_checkout=$ffmpeg_git_checkout\n" \
            "ffmpeg_source_dir=$ffmpeg_source_dir\n" \
            "build_svt_hevc=$build_svt_hevc\n" \
            "build_svt_vp9=$build_svt_vp9\n" \
            "build_dependencies_only=$build_dependencies_only\n" \
            "original_cpu_count=$original_cpu_count\n" ; shift;;
    *) break;;
  esac
done