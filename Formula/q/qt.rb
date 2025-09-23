class Qt < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.2/single/qt-everywhere-src-6.9.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.2/single/qt-everywhere-src-6.9.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.2/single/qt-everywhere-src-6.9.2.tar.xz"
  sha256 "643f1fe35a739e2bf5e1a092cfe83dbee61ff6683684e957351c599767ca279c"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "fc1ad41a8b0ceb5f6047afd936719fb11ae7e253bba51b2b0335635c85b47737"
    sha256 cellar: :any, arm64_ventura: "9f859faa1731e2ecc5bbb169b3ed89b01f2b6549c7ce6f3b33c4b75eb0316bba"
    sha256 cellar: :any, sonoma:        "95950612543fe870bae285a67027609f0bee2fc389cacccd036b5a794f1c4ce2"
    sha256 cellar: :any, ventura:       "67063fcac412aeeda3ae3a911b109f2ad2b031761f264bbe0fdb9ad76a6d1b48"
    sha256               x86_64_linux:  "e87e7711c808aa3c97e70c44f122bfdbd3d2ce695deb44282540cd67ed223cfc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on maximum_macos: [:sonoma, :build] # https://bugreports.qt.io/browse/QTBUG-128900
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader" => [:build, :test]
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "hunspell"
  depends_on "icu4c@77"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk" => [:build, :test]
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    # TODO: depends_on "bluez"
    depends_on "expat"
    depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "gdk-pixbuf"
    depends_on "gstreamer"
    depends_on "gtk+3"
    # TODO: depends_on "gypsy"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxcomposite"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxml2"
    depends_on "libxrandr"
    depends_on "libxslt"
    depends_on "libxtst"
    depends_on "little-cms2"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nspr"
    depends_on "nss"
    depends_on "openjpeg"
    depends_on "opus"
    depends_on "pango"
    depends_on "pulseaudio"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util"
    depends_on "xcb-util-cursor"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # Apply Arch Linux patches for assimp 6 support
  # Issue ref: https://bugreports.qt.io/browse/QTBUG-139028 / https://bugreports.qt.io/browse/QTBUG-139029
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-3d/-/raw/811dd8b18b4042f7120722b63953499830b51ddd/assimp-6.patch"
    sha256 "244589b0a353da757d61ce6b86d4fcf2fc8c11e9c0d9c5b109180cec9273055a"
    directory "qt3d"
  end
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-quick3d/-/raw/2c6f918ee81adb61290cf56453c2d67e5dce259f/assimp-6.patch"
    sha256 "573f00cdad90d77786fba80066d61d5ee97fc56a8b11d0896949acd16bda8e91"
    directory "qtquick3d"
  end

  # Backport support for FFmpeg 8.0 from Chromium
  # https://chromium.googlesource.com/chromium/src/media/+/065e95ae56bbba9b6c8832864c1f0ab89ae777b7
  patch :DATA

  def install
    python3 = "python3.13"

    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "qtwebengine/src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
              'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "qtwebengine/src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"

    # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
    # This fixes invocation of Assistant via the Help menu of apps like Designer and
    # Linguist as they originally relied on Assistant.app being in `bin`.
    assistant_files = %w[
      qttools/src/designer/src/designer/assistantclient.cpp
      qttools/src/linguist/linguist/mainwindow.cpp
    ]
    inreplace assistant_files, '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'

    # We prefer CMake `-DQT_FEATURE_system*=ON` arg over configure `-system-*` arg
    # since the latter may be ignored when auto-detection fails.
    #
    # We disable clang feature to avoid linkage to `llvm`. This is how we have always
    # built on macOS and it prevents complicating `llvm` version bumps on Linux.
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DINSTALL_ARCHDATADIR=share/qt
      -DINSTALL_DATADIR=share/qt
      -DINSTALL_EXAMPLESDIR=share/qt/examples
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_TESTSDIR=share/qt/tests

      -DFEATURE_sql_mysql=OFF
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DQT_FEATURE_clang=OFF
      -DQT_FEATURE_relocatable=OFF

      -DFEATURE_pkg_config=ON
      -DQT_FEATURE_system_assimp=ON
      -DQT_FEATURE_system_doubleconversion=ON
      -DQT_FEATURE_system_freetype=ON
      -DQT_FEATURE_system_harfbuzz=ON
      -DQT_FEATURE_system_hunspell=ON
      -DQT_FEATURE_system_jpeg=ON
      -DQT_FEATURE_system_libb2=ON
      -DQT_FEATURE_system_pcre2=ON
      -DQT_FEATURE_system_png=ON
      -DQT_FEATURE_system_sqlite=ON
      -DQT_FEATURE_system_tiff=ON
      -DQT_FEATURE_system_webp=ON
      -DQT_FEATURE_system_zlib=ON
      -DQT_FEATURE_webengine_proprietary_codecs=ON
      -DQT_FEATURE_webengine_kerberos=ON
      -DQT_ALLOW_SYMLINK_IN_PATHS=ON
    ]

    cmake_args += if OS.mac?
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      # NOTE: `chromium` should be built with the latest SDK because it uses
      # `___builtin_available` to ensure compatibility.
      #
      # Chromium needs Xcode 15.3+ and using LLVM Clang is not supported on macOS
      # See https://bugreports.qt.io/browse/QTBUG-130922
      cmake_args << "-DBUILD_qtwebengine=OFF" if MacOS::Xcode.version < "15.3"

      cmake_args << "-DQT_FORCE_WARN_APPLE_SDK_AND_XCODE_CHECK=ON" if MacOS.version <= :monterey

      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0
        -DQT_FEATURE_ffmpeg=OFF
      ]
    else
      # For QtWebEngine arguments:
      # * The vendored copy of `libvpx` is used for VA-API hardware acceleration,
      #   see https://codereview.qt-project.org/c/qt/qtwebengine/+/454908
      # * The vendored copy of `re2` is used to avoid rebuilds with `re2` version
      #   bumps and due to frequent API incompatibilities in Qt's copy of Chromium
      # * On macOS Chromium will always use bundled copies and the
      #   -DQT_FEATURE_webengine_system_*=ON arguments are ignored.
      # * As of Qt 6.6.0, webengine_ozone_x11 feature appears to be mandatory for Linux.
      %w[
        -DQT_FEATURE_xcb=ON
        -DQT_FEATURE_system_xcb_xinput=ON
        -DQT_FEATURE_webengine_ozone_x11=ON
        -DQT_FEATURE_webengine_system_alsa=ON
        -DQT_FEATURE_webengine_system_ffmpeg=ON
        -DQT_FEATURE_webengine_system_freetype=ON
        -DQT_FEATURE_webengine_system_harfbuzz=ON
        -DQT_FEATURE_webengine_system_icu=ON
        -DQT_FEATURE_webengine_system_lcms2=ON
        -DQT_FEATURE_webengine_system_libevent=ON
        -DQT_FEATURE_webengine_system_libjpeg=ON
        -DQT_FEATURE_webengine_system_libpng=ON
        -DQT_FEATURE_webengine_system_libxml=ON
        -DQT_FEATURE_webengine_system_libwebp=ON
        -DQT_FEATURE_webengine_system_minizip=ON
        -DQT_FEATURE_webengine_system_opus=ON
        -DQT_FEATURE_webengine_system_poppler=ON
        -DQT_FEATURE_webengine_system_pulseaudio=ON
        -DQT_FEATURE_webengine_system_snappy=ON
        -DQT_FEATURE_webengine_system_zlib=ON
      ]
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", "#{Superenv.shims_path}/", ""

    # Install a qtversion.xml to ease integration with QtCreator
    # As far as we can tell, there is no ability to make the Qt buildsystem
    # generate this and it's in the Qt source tarball at all.
    # Multiple people on StackOverflow have asked for this and it's a pain
    # to add Qt to QtCreator (the official IDE) without it.
    # Given Qt upstream seems extremely unlikely to accept this: let's ship our
    # own version.
    # If you read this and you can eliminate it or upstream it: please do!
    # More context in https://github.com/Homebrew/homebrew-core/pull/124923
    (share/"qtcreator/QtProject/qtcreator/qtversion.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE QtCreatorQtVersions>
      <qtcreator>
      <data>
        <variable>QtVersion.0</variable>
        <valuemap type="QVariantMap">
        <value type="int" key="Id">1</value>
        <value type="QString" key="Name">Qt %{Qt:Version} (#{HOMEBREW_PREFIX})</value>
        <value type="QString" key="QMakePath">#{opt_bin}/qmake</value>
        <value type="QString" key="QtVersion.Type">Qt4ProjectManager.QtVersion.Desktop</value>
        <value type="QString" key="autodetectionSource"></value>
        <value type="bool" key="isAutodetected">false</value>
        </valuemap>
      </data>
      <data>
        <variable>Version</variable>
        <value type="int">1</value>
      </data>
      </qtcreator>
    XML

    return unless OS.mac?

    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      # Some dependents' test use include path (e.g. `gecode` and `qwt`)
      include.install_symlink f/"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  def caveats
    <<~EOS
      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{HOMEBREW_PREFIX}
    EOS
  end

  test do
    webengine_supported = !OS.mac? || MacOS.version > :ventura
    modules = %w[Core Gui Widgets Sql Concurrent 3DCore Svg Quick3D Network NetworkAuth]
    modules << "WebEngineCore" if webengine_supported

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~EOS
      QT += #{modules.join(" ").downcase}
      TARGET = test
      CONFIG += console
      CONFIG -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    EOS

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <QVulkanInstance>
      #{"#include <QtWebEngineCore>" if webengine_supported}
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication app(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        QVulkanInstance inst;
        // See https://github.com/actions/runner-images/issues/1779
        // if (!inst.create())
        //   qFatal("Failed to create Vulkan instance: %d", inst.errorCode());
        for(const char* fmt:{"bmp", "cur", "gif",
          #ifdef __APPLE__
            "heic", "heif",
          #endif
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_VULKAN_LIB"] = Formula["vulkan-loader"].opt_lib/shared_library("libvulkan")
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"

    # Check QT_INSTALL_PREFIX is HOMEBREW_PREFIX to support split `qt-*` formulae
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/qmake -query QT_INSTALL_PREFIX").chomp
  end
end

__END__
--- a/qtwebengine/src/3rdparty/chromium/media/ffmpeg/ffmpeg_common.cc
+++ b/qtwebengine/src/3rdparty/chromium/media/ffmpeg/ffmpeg_common.cc
@@ -263,22 +263,22 @@
 static VideoCodecProfile ProfileIDToVideoCodecProfile(int profile) {
   // Clear out the CONSTRAINED & INTRA flags which are strict subsets of the
   // corresponding profiles with which they're used.
-  profile &= ~FF_PROFILE_H264_CONSTRAINED;
-  profile &= ~FF_PROFILE_H264_INTRA;
+  profile &= ~AV_PROFILE_H264_CONSTRAINED;
+  profile &= ~AV_PROFILE_H264_INTRA;
   switch (profile) {
-    case FF_PROFILE_H264_BASELINE:
+    case AV_PROFILE_H264_BASELINE:
       return H264PROFILE_BASELINE;
-    case FF_PROFILE_H264_MAIN:
+    case AV_PROFILE_H264_MAIN:
       return H264PROFILE_MAIN;
-    case FF_PROFILE_H264_EXTENDED:
+    case AV_PROFILE_H264_EXTENDED:
       return H264PROFILE_EXTENDED;
-    case FF_PROFILE_H264_HIGH:
+    case AV_PROFILE_H264_HIGH:
       return H264PROFILE_HIGH;
-    case FF_PROFILE_H264_HIGH_10:
+    case AV_PROFILE_H264_HIGH_10:
       return H264PROFILE_HIGH10PROFILE;
-    case FF_PROFILE_H264_HIGH_422:
+    case AV_PROFILE_H264_HIGH_422:
       return H264PROFILE_HIGH422PROFILE;
-    case FF_PROFILE_H264_HIGH_444_PREDICTIVE:
+    case AV_PROFILE_H264_HIGH_444_PREDICTIVE:
       return H264PROFILE_HIGH444PREDICTIVEPROFILE;
     default:
       DVLOG(1) << "Unknown profile id: " << profile;
@@ -289,23 +289,23 @@
 static int VideoCodecProfileToProfileID(VideoCodecProfile profile) {
   switch (profile) {
     case H264PROFILE_BASELINE:
-      return FF_PROFILE_H264_BASELINE;
+      return AV_PROFILE_H264_BASELINE;
     case H264PROFILE_MAIN:
-      return FF_PROFILE_H264_MAIN;
+      return AV_PROFILE_H264_MAIN;
     case H264PROFILE_EXTENDED:
-      return FF_PROFILE_H264_EXTENDED;
+      return AV_PROFILE_H264_EXTENDED;
     case H264PROFILE_HIGH:
-      return FF_PROFILE_H264_HIGH;
+      return AV_PROFILE_H264_HIGH;
     case H264PROFILE_HIGH10PROFILE:
-      return FF_PROFILE_H264_HIGH_10;
+      return AV_PROFILE_H264_HIGH_10;
     case H264PROFILE_HIGH422PROFILE:
-      return FF_PROFILE_H264_HIGH_422;
+      return AV_PROFILE_H264_HIGH_422;
     case H264PROFILE_HIGH444PREDICTIVEPROFILE:
-      return FF_PROFILE_H264_HIGH_444_PREDICTIVE;
+      return AV_PROFILE_H264_HIGH_444_PREDICTIVE;
     default:
       DVLOG(1) << "Unknown VideoCodecProfile: " << profile;
   }
-  return FF_PROFILE_UNKNOWN;
+  return AV_PROFILE_UNKNOWN;
 }
 
 SampleFormat AVSampleFormatToSampleFormat(AVSampleFormat sample_format,
@@ -443,7 +443,7 @@
     // TODO(dalecurtis): Just use the profile from the codec context if ffmpeg
     // ever starts supporting xHE-AAC.
     // FFmpeg provides the (defined_profile - 1) for AVCodecContext::profile
-    if (codec_context->profile == FF_PROFILE_UNKNOWN ||
+    if (codec_context->profile == AV_PROFILE_UNKNOWN ||
         codec_context->profile == mp4::AAC::kXHeAAcType - 1) {
       // Errors aren't fatal here, so just drop any MediaLog messages.
       NullMediaLog media_log;
@@ -661,16 +661,16 @@
       break;
     case VideoCodec::kVP9:
       switch (codec_context->profile) {
-        case FF_PROFILE_VP9_0:
+        case AV_PROFILE_VP9_0:
           profile = VP9PROFILE_PROFILE0;
           break;
-        case FF_PROFILE_VP9_1:
+        case AV_PROFILE_VP9_1:
           profile = VP9PROFILE_PROFILE1;
           break;
-        case FF_PROFILE_VP9_2:
+        case AV_PROFILE_VP9_2:
           profile = VP9PROFILE_PROFILE2;
           break;
-        case FF_PROFILE_VP9_3:
+        case AV_PROFILE_VP9_3:
           profile = VP9PROFILE_PROFILE3;
           break;
         default:
--- a/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_aac_bitstream_converter.cc
+++ b/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_aac_bitstream_converter.cc
@@ -68,17 +68,17 @@
   hdr[1] |= 1;
 
   switch (audio_profile) {
-    case FF_PROFILE_AAC_MAIN:
+    case AV_PROFILE_AAC_MAIN:
       break;
-    case FF_PROFILE_AAC_HE:
-    case FF_PROFILE_AAC_HE_V2:
-    case FF_PROFILE_AAC_LOW:
+    case AV_PROFILE_AAC_HE:
+    case AV_PROFILE_AAC_HE_V2:
+    case AV_PROFILE_AAC_LOW:
       hdr[2] |= (1 << 6);
       break;
-    case FF_PROFILE_AAC_SSR:
+    case AV_PROFILE_AAC_SSR:
       hdr[2] |= (2 << 6);
       break;
-    case FF_PROFILE_AAC_LTP:
+    case AV_PROFILE_AAC_LTP:
       hdr[2] |= (3 << 6);
       break;
     default:
