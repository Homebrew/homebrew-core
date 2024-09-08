class Qt < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  revision 2
  head "https://code.qt.io/qt/qt5.git", branch: "dev"

  stable do
    url "https://download.qt.io/official_releases/qt/6.7/6.7.0/single/qt-everywhere-src-6.7.0.tar.xz"
    mirror "https://qt.mirror.constant.com/archive/qt/6.7/6.7.0/single/qt-everywhere-src-6.7.0.tar.xz"
    mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.7/6.7.0/single/qt-everywhere-src-6.7.0.tar.xz"
    sha256 "bf5089912364f99cf9baf6c109de76a3172eec6267f148c69800575c47f90087"

    # Backport support for FFMpeg 7.
    # Ref: https://bugreports.qt.io/browse/QTBUG-125227
    patch do
      # Use Fedora's backport of https://github.com/qt/qtwebengine-chromium/commit/b30e3535717e1cb970c6e4095b412a2c5fdbce40
      url "https://src.fedoraproject.org/rpms/qt6-qtwebengine/raw/864539f2140a11fda9bf3ef878a2e627f04f0b2d/f/qtwebengine-fix-building-with-system-ffmpeg.patch"
      sha256 "70b8c468be1954b8dad59243069c6369d7c6eae332f154d99e3027b9119eb7c5"
      directory "qtwebengine"
    end
    patch do
      url "https://github.com/qt/qtwebengine-chromium/commit/65aaac35d040aef90c2e9f41a651b5a23470e457.patch?full_index=1"
      sha256 "2875e9c534da34902fb113b4171d7a4960e6bc27f6ad45d49929ecf667856d48"
      directory "qtwebengine/src/3rdparty"
    end
    patch do
      url "https://github.com/qt/qtwebengine-chromium/commit/d9944bcb991c981574a229e5267e535b4eac8e1c.patch?full_index=1"
      sha256 "11d8c7db91e76ea886dd0f30aedb3bfb33211f6ba39236d684ad63bfe80682ff"
      directory "qtwebengine/src/3rdparty"
    end
    # Backport of https://github.com/qt/qtwebengine-chromium/commit/afcbb2eab7c5b0329ad0045782768dd2805d6a05
    patch :DATA
  end

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e91ea08a9b8cfcbcf43b932875aeb2201eae09806e59655be08685b9acd7624d"
    sha256 cellar: :any,                 arm64_ventura:  "6ef7081cc3284bfb4e7ec02e5f3aa94150128cab70ddd6ca9e5ddfd9df963d15"
    sha256 cellar: :any,                 arm64_monterey: "c81a6fa0b3f95518bbb06e1c97332db4c6561bc63e528a3310863cde489d00a0"
    sha256 cellar: :any,                 sonoma:         "dee140746e16c9d7acb484daa9f957f9cd8b337513573c3a084b3fa7476fcbf0"
    sha256 cellar: :any,                 ventura:        "6f69293a85e2ce056bf25c9ef54ce6ccedee49f8856dec0cec9c579a3598d727"
    sha256 cellar: :any,                 monterey:       "7df9c26be7011eae551a272b2256f9525a66a56c5a79007d82514d9b6fb7da4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e77123a7c36a4480792d8566a760ec3c80c51fe4c8f0c5171e9dbd83698fed4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
  depends_on "icu4c"
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
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk" => [:build, :test]
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    # TODO: depends_on "bluez"
    depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "gstreamer"
    # TODO: depends_on "gypsy"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libxcomposite"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
    depends_on "little-cms2"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
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

  fails_with gcc: "5"

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # Backport fix to allow QtWebEngine to build with ninja>=1.12.0.
  # Issue ref: https://bugreports.qt.io/browse/QTBUG-124375
  patch do
    url "https://github.com/qt/qtwebengine-chromium/commit/a766045f65f934df3b5f1aa63bc86fbb3e003a09.patch?full_index=1"
    sha256 "4d097145bf99a61704a99bf3e4b449b9bf613ae1f06efdcf44b881a045c5230c"
    directory "qtwebengine/src/3rdparty"
  end

  def install
    python3 = "python3.12"

    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

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

    # Allow generating unofficial pkg-config files for macOS to be used by other formulae.
    # Upstream currently does not provide them: https://bugreports.qt.io/browse/QTBUG-86080
    inreplace "qtbase/cmake/QtPkgConfigHelpers.cmake", "(NOT UNIX OR QT_FEATURE_framework)", "(NOT UNIX)"

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

      -archdatadir share/qt
      -datadir share/qt
      -examplesdir share/qt/examples
      -hostdatadir share/qt/mkspecs
      -testsdir share/qt/tests

      -no-sql-mysql
      -no-sql-odbc
      -no-sql-psql
    ]

    # We prefer CMake `-DQT_FEATURE_system*=ON` arg over configure `-system-*` arg
    # since the latter may be ignored when auto-detection fails.
    #
    # We disable clang feature to avoid linkage to `llvm`. This is how we have always
    # built on macOS and it prevents complicating `llvm` version bumps on Linux.
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %w[
      -DFEATURE_pkg_config=ON
      -DQT_FEATURE_clang=OFF
      -DQT_FEATURE_relocatable=OFF
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
      config_args << "-sysroot" << MacOS.sdk_path.to_s
      # NOTE: `chromium` should be built with the latest SDK because it uses
      # `___builtin_available` to ensure compatibility.
      config_args << "-skip" << "qtwebengine" if DevelopmentTools.clang_build_version <= 1200

      # FIXME: `-DQT_FEATURE_webengine_vulkan=OFF` is a workaround for
      # error: use of undeclared identifier 'importMemoryHandleInfo'
      # Remove once properly handled by Qt.
      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0
        -DQT_FEATURE_ffmpeg=OFF
        -DQT_FEATURE_webengine_vulkan=OFF
      ]
    else
      # Explicitly specify QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX so
      # that cmake does not think $HOMEBREW_PREFIX/lib is the install prefix.
      #
      # For QtWebEngine arguments:
      # * The vendored copy of `libvpx` is used for VA-API hardware acceleration,
      #   see https://codereview.qt-project.org/c/qt/qtwebengine/+/454908
      # * The vendored copy of `re2` is used to avoid rebuilds with `re2` version
      #   bumps and due to frequent API incompatibilities in Qt's copy of Chromium
      # * On macOS Chromium will always use bundled copies and the
      #   -DQT_FEATURE_webengine_system_*=ON arguments are ignored.
      # * As of Qt 6.6.0, webengine_ozone_x11 feature appears to be mandatory for Linux.
      %W[
        -DQT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX=#{prefix}
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

    system "./configure", *config_args, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
    system "ninja install_qch_docs"

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
    qtversion_xml = share/"qtcreator/QtProject/qtcreator/qtversion.xml"
    qtversion_xml.dirname.mkpath
    qtversion_xml.write <<~XML
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

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    # Tracking issues:
    # https://bugreports.qt.io/browse/QTBUG-86080
    # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/6363
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end

    # Modify unofficial pkg-config files to fix up paths and use frameworks.
    # Also move them to `libexec` as they are not guaranteed to work for users,
    # i.e. there is no upstream or Homebrew support.
    lib.glob("pkgconfig/*.pc") do |pc|
      inreplace pc do |s|
        s.gsub! " -L${libdir}", " -F${libdir}", audit_result: false
        s.gsub! " -lQt6", " -framework Qt", audit_result: false
        s.gsub! " -Ilib/", " -I${libdir}/", audit_result: false
      end
      (libexec/"lib/pkgconfig").install pc
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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Gui Widgets Sql Concurrent
        3DCore Svg Quick3D Network NetworkAuth WebEngineCore REQUIRED)

      add_executable(test
        main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Widgets
        Qt6::Sql Qt6::Concurrent Qt6::3DCore Qt6::Svg Qt6::Quick3D
        Qt6::Network Qt6::NetworkAuth Qt6::Gui Qt6::WebEngineCore
      )
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core svg 3dcore network networkauth quick3d \
        sql gui widgets webenginecore
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    EOS

    (testpath/"main.cpp").write <<~EOS
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
      #include <QtWebEngineCore>
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
    EOS

    ENV["QT_VULKAN_LIB"] = Formula["vulkan-loader"].opt_lib/shared_library("libvulkan")
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH" if OS.mac? && MacOS.version > :mojave
    system bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end

__END__
diff --git a/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.cc b/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.cc
index aaab17bdc3b9c157981f2708c680eea03657f211..737ba737872ca5df4ee9a5efe03d17573a1f2e49 100644
--- a/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.cc
+++ b/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.cc
@@ -142,7 +142,7 @@ bool FFmpegVideoDecoder::IsCodecSupported(VideoCodec codec) {
 }

 FFmpegVideoDecoder::FFmpegVideoDecoder(MediaLog* media_log)
-    : media_log_(media_log) {
+    : media_log_(media_log), timestamp_map_(128) {
   DVLOG(1) << __func__;
   DETACH_FROM_SEQUENCE(sequence_checker_);
 }
@@ -371,8 +371,10 @@ bool FFmpegVideoDecoder::FFmpegDecode(const DecoderBuffer& buffer) {
     DCHECK(packet->data);
     DCHECK_GT(packet->size, 0);

-    // Let FFmpeg handle presentation timestamp reordering.
-    codec_context_->reordered_opaque = buffer.timestamp().InMicroseconds();
+    const int64_t timestamp = buffer.timestamp().InMicroseconds();
+    const TimestampId timestamp_id = timestamp_id_generator_.GenerateNextId();
+    timestamp_map_.Put(std::make_pair(timestamp_id, timestamp));
+    packet->opaque = reinterpret_cast<void*>(timestamp_id.GetUnsafeValue());
   }
   FFmpegDecodingLoop::DecodeStatus decode_status = decoding_loop_->DecodePacket(
       packet, base::BindRepeating(&FFmpegVideoDecoder::OnNewFrame,
@@ -431,7 +433,12 @@ bool FFmpegVideoDecoder::OnNewFrame(AVFrame* frame) {
   }
   gfx::Size natural_size = aspect_ratio.GetNaturalSize(visible_rect);

-  const auto pts = base::Microseconds(frame->reordered_opaque);
+  const auto ts_id = TimestampId(reinterpret_cast<size_t>(frame->opaque));
+  const auto ts_lookup = timestamp_map_.Get(ts_id);
+  if (ts_lookup == timestamp_map_.end()) {
+    return false;
+  }
+  const auto pts = base::Microseconds(std::get<1>(*ts_lookup));
   auto video_frame = VideoFrame::WrapExternalDataWithLayout(
       opaque->layout, visible_rect, natural_size, opaque->data, opaque->size,
       pts);
@@ -506,8 +513,10 @@ bool FFmpegVideoDecoder::ConfigureDecoder(const VideoDecoderConfig& config,
   codec_context_->thread_count = GetFFmpegVideoDecoderThreadCount(config);
   codec_context_->thread_type =
       FF_THREAD_SLICE | (low_delay ? 0 : FF_THREAD_FRAME);
+
   codec_context_->opaque = this;
   codec_context_->get_buffer2 = GetVideoBufferImpl;
+  codec_context_->flags |= AV_CODEC_FLAG_COPY_OPAQUE;

   if (decode_nalus_)
     codec_context_->flags2 |= AV_CODEC_FLAG2_CHUNKS;
diff --git a/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.h b/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.h
index d02cb89c3ddf7cee0d1a79ee095eae5f52ff5111..0a2de1c623ffff7dc9c5d381344714e9ee3d2f2a 100644
--- a/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.h
+++ b/qtwebengine/src/3rdparty/chromium/media/filters/ffmpeg_video_decoder.h
@@ -7,10 +7,12 @@

 #include <memory>

+#include "base/containers/lru_cache.h"
 #include "base/functional/callback.h"
 #include "base/memory/raw_ptr.h"
 #include "base/memory/scoped_refptr.h"
 #include "base/sequence_checker.h"
+#include "base/types/id_type.h"
 #include "media/base/supported_video_decoder_config.h"
 #include "media/base/video_decoder.h"
 #include "media/base/video_decoder_config.h"
@@ -87,6 +89,20 @@ class MEDIA_EXPORT FFmpegVideoDecoder : public VideoDecoder {
   // FFmpeg structures owned by this object.
   std::unique_ptr<AVCodecContext, ScopedPtrAVFreeContext> codec_context_;

+  // The gist here is that timestamps need to be 64 bits to store microsecond
+  // precision. A 32 bit integer would overflow at ~35 minutes at this level of
+  // precision. We can't cast the timestamp to the void ptr object used by the
+  // opaque field in ffmpeg then, because it would lose data on a 32 bit build.
+  // However, we don't actually have 2^31 timestamped frames in a single
+  // playback, so it's fine to use the 32 bit value as a key in a map which
+  // contains the actual timestamps. Additionally, we've in the past set 128
+  // outstanding frames for re-ordering as a limit for cross-thread decoding
+  // tasks, so we'll do that here too with the LRU cache.
+  using TimestampId = base::IdType<int64_t, size_t, 0>;
+
+  TimestampId::Generator timestamp_id_generator_;
+  base::LRUCache<TimestampId, int64_t> timestamp_map_;
+
   VideoDecoderConfig config_;

   scoped_refptr<FrameBufferPool> frame_pool_;
