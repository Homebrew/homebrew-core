class QtAT5 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  # NOTE: Use *.diff for GitLab/KDE patches to avoid their checksums changing.
  url "https://download.qt.io/archive/qt/5.15/5.15.19/single/qt-everywhere-opensource-src-5.15.19.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.19/single/qt-everywhere-opensource-src-5.15.19.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.19/single/qt-everywhere-opensource-src-5.15.19.tar.xz"
  sha256 "173c2326dae138bbb0d98921e9d911e55c00163d93a6db29f294b5e19ff306ae"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  compatibility_version 1

  livecheck do
    skip "Qt 5.15.19 is the final release"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "649b3d8494ceb7a957a2806451b7fc6661ea2a9fbbdd63e1174a853b4f932226"
    sha256 cellar: :any,                 arm64_sequoia: "f9981c2cffae3a70a3e9c09e2b581c74566a2dd9294c6dee6e01ff6facf7935f"
    sha256 cellar: :any,                 arm64_sonoma:  "06e23a0b11dae387d4267b7f497cf57d64373094a876fdfefe1672b935976c58"
    sha256 cellar: :any,                 sonoma:        "0811fdc7dce91d28f6c031079ec24e85f1f3bfbccbc66415e98aef7581d44e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63a1e7642ed0f95ef9bde80e6620ffe648970a3f04b49180e5a6096db4c71d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea2a794903c1c9e82c6b65d1d30d58aaa19cf6e638f23ae135d9e6bf5b37ad4"
  end

  keg_only :versioned_formula

  # Deprecating on expected date of Qt 5.15.19 open-source release which is
  # planned for 1 year after the commercial release date of 2025-05-19[^1].
  # Standard support officially ended on 2025-05-26 and Qt5 is now in EoS[^2].
  # Any new CVEs found are no longer being fixed since commercial release.
  # Also, we rely on Linux distro patches and they are planning removal too,
  # e.g. Alpine[^3], Gentoo[^4] and Ubuntu[^5].
  #
  # [^1]: https://www.qt.io/blog/commercial-lts-qt-5.15.19-released
  # [^2]: https://www.qt.io/blog/extended-security-maintenance-for-qt-5.15-begins-may-2025
  # [^3]: https://gitlab.alpinelinux.org/alpine/aports/-/issues/17114
  # [^4]: https://bugs.gentoo.org/948836
  # [^5]: https://discourse.ubuntu.com/t/removing-qt-5-from-ubuntu-before-the-release-of-26-04-lts/49296
  deprecate! date: "2026-05-19", because: :unsupported
  disable! date: "2027-05-19", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "at-spi2-core" => :build
    depends_on "libxext" => :build
    depends_on "alsa-lib"
    depends_on "dbus" => :no_linkage
    depends_on "double-conversion"
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "icu4c@78"
    depends_on "libdrm"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxcomposite"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2-compat"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
    depends_on "zlib-ng-compat"
  end

  # Specify conflict due to auto-linking of keg-only versioned formulae
  conflicts_with "qt3d", "qtbase", "qtcharts", "qtconnectivity", "qtdatavis3d", "qtdeclarative",
                 "qtmultimedia", "qtnetworkauth", "qtpositioning", "qtquick3d", "qtremoteobjects", "qtscxml",
                 "qtsensors", "qtserialport", "qtspeech", "qtsvg", "qttools", "qtwebchannel", "qtwebsockets",
                 because: "both link conflicting binaries"

  # Fix build with ICU 75
  patch do
    on_linux do
      url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/35d566724c48180c9a372c2ed50a253871a51574.diff"
      sha256 "9e61d46c0a8ae39903cbcbb228e384f2878a06e50448f3bba60ec65fe2890081"
      directory "qtlocation/src/3rdparty/mapbox-gl-native"
      type :cherry_pick
    end
  end

  # Fix build with Xcode 14.3.
  patch do
    url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocation/src/3rdparty/mapbox-gl-native"
    type :cherry_pick
    resolves "https://bugreports.qt.io/browse/QTBUG-112906"
  end

  # Fix build with Xcode 26 with backport from Qt6
  # https://github.com/qt/qtbase/commit/cdb33c3d5621ce035ad6950c8e2268fe94b73de5
  patch :DATA

  # Apply patch from Gentoo bug tracker to fix build on macOS.
  # Not possible to upstream as the final Qt5 commercial release is done.
  patch do
    on_sequoia :or_newer do
      url "https://bugs.gentoo.org/attachment.cgi?id=916782"
      sha256 "6b655ba61128c04811e0426a1e25456914fc79c845469da6df10f2d3e29aa510"
      directory "qtlocation"
      type :unofficial
      resolves "https://bugs.gentoo.org/936486"
    end
  end

  # Backport Boost fix for newer Clang
  patch do
    on_tahoe :or_newer do
      url "https://github.com/boostorg/mpl/commit/8499ae7e4ff0cf798367ebe6ea9fb991aa43db6c.patch?full_index=1"
      sha256 "2bac4e4eaabce759c09b86b716149aad8e2bfcc921d7d946a31d24a3b9e25ac3"
      directory "qtlocation/src/3rdparty/mapbox-gl-native/deps/boost/1.65.1"
      type :backport
      resolves "https://github.com/boostorg/mpl/pull/77"
    end
  end
  patch do
    on_tahoe :or_newer do
      url "https://github.com/boostorg/mpl/commit/fb6b861834e29a93ba71a2e2501a42ecfd3c5655.patch?full_index=1"
      sha256 "1213dc3e1b8d9cfc9ed42fc1639f10fa350f2a921d378b184c2c0a1d4936f7f3"
      directory "qtlocation/src/3rdparty/mapbox-gl-native/deps/boost/1.65.1"
      type :backport
      resolves "https://github.com/boostorg/mpl/pull/77"
    end
  end

  # Apply Debian patch to fix build with GCC 13+
  patch do
    url "https://salsa.debian.org/qt-kde-team/qt/qtlocation/-/raw/4ec161bda76cd4c80d2e50fff223a94594cc6b4c/debian/patches/gcc_13.diff"
    sha256 "85ef9bb775540d639cea03894101ab2b7476f633cbb7ff49a1ea0a6bbca82168"
    directory "qtlocation"
    type :unofficial
    resolves "https://github.com/mapbox/mapbox-gl-native/pull/16669"
  end

  def install
    # Remove QtWebEngine. It has a copy of Chromium with unfixed vulnerabilities,
    # requires dozens of patches to build and is becoming more unmaintainable.
    # This is the same decision made by Arch Linux[^1].
    #
    # [^1]: https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/U45C4RAW4IXVLO376XGFNLEGGFFXCULV/
    rm_r("qtwebengine")

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -system-freetype
      -system-libjpeg
      -system-libmd4c
      -system-libpng
      -system-pcre
      -system-sqlite
      -system-zlib
      -skip qtwebengine
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-no-assimp" if Hardware::CPU.arm?

      # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
      # This fixes invocation of Assistant via the Help menu of apps like Designer and
      # Linguist as they originally relied on Assistant.app being in `bin`.
      assistant_files = %w[
        qttools/src/designer/src/designer/assistantclient.cpp
        qttools/src/linguist/linguist/mainwindow.cpp
      ]
      inreplace assistant_files, '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'
    else
      args << "-R#{lib}"
      # https://bugreports.qt.io/browse/QTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-no-sql-mysql"

      # Avoid linkage to LLVM for same reason as Qt6
      args << "-no-feature-qdoc"

      # Use additional system libraries on Linux.
      args += %w[
        -system-doubleconversion
        -system-harfbuzz
      ]
    end

    # Work around Clang failure in bundled Boost and V8:
    # error: integer value -1 is outside the valid range of values [0, 3] for this enumeration type
    args << "QMAKE_CXXFLAGS+=-Wno-enum-constexpr-conversion" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Remove reference to shims directory
    inreplace prefix/"mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{formula_opt_bin("pkgconf")}/pkg-config"

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
        <value type="QString" key="Name">Qt %{Qt:Version} (#{opt_prefix})</value>
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
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.

      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{opt_prefix}

      QtWebEngine is no longer included as its Chromium has unfixed vulnerabilities.
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~QMAKE
      QT       += core
      QT       -= gui
      TARGET    = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE  = app
      SOURCES  += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    CPP

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_path_exists testpath/"hello"
    assert_path_exists testpath/"main.o"
    system "./hello"
  end
end

__END__
--- a/qtbase/mkspecs/common/mac.conf
+++ b/qtbase/mkspecs/common/mac.conf
@@ -18,8 +18,7 @@ QMAKE_LIBDIR            =
 
 # sdk.prf will prefix the proper SDK sysroot
 QMAKE_INCDIR_OPENGL     = \
-    /System/Library/Frameworks/OpenGL.framework/Headers \
-    /System/Library/Frameworks/AGL.framework/Headers/
+    /System/Library/Frameworks/OpenGL.framework/Headers
 
 QMAKE_FIX_RPATH         = install_name_tool -id
 
@@ -30,7 +29,7 @@ QMAKE_LFLAGS_REL_RPATH  =
 QMAKE_REL_RPATH_BASE    = @loader_path
 
 QMAKE_LIBS_DYNLOAD      =
-QMAKE_LIBS_OPENGL       = -framework OpenGL -framework AGL
+QMAKE_LIBS_OPENGL       = -framework OpenGL
 QMAKE_LIBS_THREAD       =
 
 QMAKE_INCDIR_WAYLAND    =
