# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  # NOTE: Use *.diff for GitLab/KDE patches to avoid their checksums changing.
  url "https://download.qt.io/official_releases/qt/5.15/5.15.17/single/qt-everywhere-opensource-src-5.15.17.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.15/5.15.17/single/qt-everywhere-opensource-src-5.15.17.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.15/5.15.17/single/qt-everywhere-opensource-src-5.15.17.tar.xz"
  sha256 "85eb566333d6ba59be3a97c9445a6e52f2af1b52fc3c54b8a2e7f9ea040a7de4"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/qt/5.15/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "114f6e5d992eb6e0ccc4228165021fd7dfa737b7546753159b8cb4f215c3c0d0"
    sha256 cellar: :any,                 arm64_sequoia: "71e99646e19f6bbfb49bef4ce5fb144967158846b6c63819f24f3769dba01570"
    sha256 cellar: :any,                 arm64_sonoma:  "37b737c30cd357390362d8b732b87a665f6f3d35b06d31951251e6e3616a37a9"
    sha256 cellar: :any,                 arm64_ventura: "7149d97837f5cecc2a773f32e855f059e7d92b1fe2502a142c97f777acb4fe66"
    sha256 cellar: :any,                 sonoma:        "18882946bb6b34ace4fae1fe0fd53bc94666823b1d8007c7add580d4128d8884"
    sha256 cellar: :any,                 ventura:       "2b768884998655899253a3887c8d01011bd609bc754c5ef897323af5cb4b361d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "343311cd12f13c145f45fcb608b4803a4aebbb1d78914ca7fcd2982feb50303c"
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

  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    depends_on "dbus"
    depends_on "double-conversion"
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
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
    depends_on "llvm"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nspr"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

  resource "qtwebengine" do
    url "https://code.qt.io/qt/qtwebengine.git",
        tag:      "v5.15.19-lts",
        revision: "a5d11cd6f8c487443c15c7e3a6cd8090b65cb313"

    # Apply FreeBSD patches for newer LLVM/Clang
    # Ref: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=281431
    on_sequoia :or_newer do
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-libc%2B%2B19"
        sha256 "45455e5b5cbeb2abf74733e550ed1c4fdc85a43de9f209dcbbe04ba6c93e1775"
      end
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-src_3rdparty_chromium_third__party_blink_renderer_platform_wtf_hash__table.h"
        sha256 "d1738d95f24fe38b5b5bc86110f9dff9c2df98f229401e162e8f8fdfa8e9ac6e"
      end
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/0ddd6468fb3cb9ba390973520517cb1ca2cd690d/www/qt5-webengine/files/patch-src_3rdparty_chromium_third__party_perfetto_include_perfetto_tracing_internal_track__event__data__source.h"
        sha256 "b75ffdf65ba35c63f208b34c908a5f0554683c7b9034f924cb2dc9b2d4f3f215"
      end
    end

    # Use Debian patches for ICU 75+, brew Ninja and Python 3.13
    patch do
      url "https://deb.debian.org/debian/pool/main/q/qtwebengine-opensource-src/qtwebengine-opensource-src_5.15.19+dfsg-3.debian.tar.xz"
      sha256 "38ef54e497ad0464950776b1055807d9e6b1a42aa0f8f76aa3b1323f7d59fa55"
      apply "patches/build-with-c++17.patch",
            "patches/ninja-1.12.patch",
            "patches/python3.13-pipes.patch"
    end

    # Backport fix for bundled libpng used on macOS
    patch do
      url "https://github.com/qt/qtwebengine-chromium/commit/eb486f33ed1109a78f2794c98aad624023ea26ea.patch?full_index=1"
      sha256 "7377fd75bd63f789563aa229ff861a1b934fe9b6052ce86d5d01f1f3fff94d89"
      directory "src/3rdparty"
    end

    # Backport fix for https://bugreports.qt.io/browse/QTBUG-138486
    patch do
      url "https://github.com/qt/qtwebengine-chromium/commit/1d29d95bf4732a2d6f46547aa2773c9e742ad52e.patch?full_index=1"
      sha256 "0bc0855a104d695acc8e9dabd5aa122b292fbd123058c0b52e7c733bcbe2d801"
      directory "src/3rdparty"
    end
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

  # Fix build with ICU 75
  patch do
    on_linux do
      url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/35d566724c48180c9a372c2ed50a253871a51574.diff"
      sha256 "9e61d46c0a8ae39903cbcbb228e384f2878a06e50448f3bba60ec65fe2890081"
      directory "qtlocation/src/3rdparty/mapbox-gl-native"
    end
  end

  # Fix build with Xcode 14.3.
  # https://bugreports.qt.io/browse/QTBUG-112906
  patch do
    url "https://invent.kde.org/qt/qt/qtlocation-mapboxgl/-/commit/5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocation/src/3rdparty/mapbox-gl-native"
  end

  # Fix build with Xcode 26 with backport from Qt6
  # https://github.com/qt/qtbase/commit/cdb33c3d5621ce035ad6950c8e2268fe94b73de5
  patch :DATA

  # Apply patch from Gentoo bug tracker (https://bugs.gentoo.org/936486) to fix build
  # on macOS. Not possible to upstream as the final Qt5 commercial release is done.
  patch do
    on_sequoia :or_newer do
      url "https://bugs.gentoo.org/attachment.cgi?id=916782"
      sha256 "6b655ba61128c04811e0426a1e25456914fc79c845469da6df10f2d3e29aa510"
      directory "qtlocation"
    end
  end

  # Below are CVE patches from https://download.qt.io/official_releases/qt/5.15/
  # detailed at https://wiki.qt.io/List_of_known_vulnerabilities_in_Qt_products

  # CVE-2024-39936
  # Remove with Qt 5.15.18
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2024-39936-qtbase-5.15.patch"
    sha256 "2cc23afba9d7e48f8faf8664b4c0324a9ac31a4191da3f18bd0accac5c7704de"
    directory "qtbase"
  end

  # CVE-2025-23050
  # Remove with Qt 5.15.19
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2025-23050-qtconnectivity-5.15.diff"
    sha256 "76e303b6465babb6d0d275792f7f3c41e3df87a6a17992e8b7b8e47272682ce7"
    directory "qtconnectivity"
  end

  # CVE-2025-30348
  # Remove with Qt 5.15.19
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2025-30348-qtbase-5.15.diff"
    sha256 "fcd011754040d961fec1b48fe9828b2c8d501f2d9c30f0f475487a590de6d3c8"
    directory "qtbase"
  end

  # CVE-2025-4211
  # Remove with Qt 5.15.19
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2025-4211-qtbase-5.15.diff"
    sha256 "7bc92fb0423f25195fcc59a851570a2f944cfeecbd843540f0e80f09b6b0e822"
    directory "qtbase"
  end

  # CVE-2025-5455
  # Remove with Qt 5.15.19
  patch do
    url "https://download.qt.io/official_releases/qt/5.15/CVE-2025-5455-qtbase-5.15.patch"
    sha256 "967fe137ee358f60ac3338f658624ae2663ec77552c38bcbd94c6f2eff107506"
    directory "qtbase"
  end

  def install
    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resources.reject { |r| r.name == "qtwebengine" }
    ENV.prepend_path "PATH", venv.root/"bin"

    rm_r(buildpath/"qtwebengine")
    (buildpath/"qtwebengine").install resource("qtwebengine")

    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "qtwebengine/src/3rdparty/chromium/build/toolchain/mac/BUILD.gn",
              'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
      -system-freetype
      -system-libjpeg
      -system-libmd4c
      -system-libpng
      -system-pcre
      -system-sqlite
      -system-zlib
      -webengine-python-version python3
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

      # Use additional system libraries on Linux.
      # Currently we have to use vendored ffmpeg because the chromium copy adds a symbol not
      # provided by the brewed version.
      # See here for an explanation of why upstream ffmpeg does not want to add this:
      # https://www.mail-archive.com/ffmpeg-devel@ffmpeg.org/msg124998.html
      # On macOS chromium will always use bundled copies and the webengine_*
      # arguments are ignored.
      args += %w[
        -system-doubleconversion
        -system-harfbuzz
        -webengine-alsa
        -webengine-icu
        -webengine-kerberos
        -webengine-opus
        -webengine-pulseaudio
        -webengine-webp
      ]

      # Homebrew-specific workaround to ignore spurious linker warnings on Linux.
      inreplace "qtwebengine/src/3rdparty/chromium/build/config/compiler/BUILD.gn",
                "fatal_linker_warnings = true",
                "fatal_linker_warnings = false"
    end

    # Work around Clang failure in bundled Boost and V8:
    # error: integer value -1 is outside the valid range of values [0, 3] for this enumeration type
    if DevelopmentTools.clang_build_version >= 1500
      args << "QMAKE_CXXFLAGS+=-Wno-enum-constexpr-conversion"
      inreplace "qtwebengine/src/3rdparty/chromium/build/config/compiler/BUILD.gn",
                /^\s*"-Wno-thread-safety-attributes",$/,
                "\\0 \"-Wno-enum-constexpr-conversion\","
    end

    # Work around Clang failure in bundled freetype: error: unknown type name 'Byte'
    # https://gitlab.freedesktop.org/freetype/freetype/-/commit/a25e85ed95dc855e42e6bb55138e27d362c5ea1e
    if DevelopmentTools.clang_build_version >= 1600
      inreplace "qtwebengine/src/3rdparty/chromium/third_party/freetype/src/src/gzip/ftzconf.h",
                "#if !defined(MACOS) && !defined(TARGET_OS_MAC)", "#if !defined(__MACTYPES__)"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Remove reference to shims directory
    inreplace prefix/"mkspecs/qmodule.pri",
              /^PKG_CONFIG_EXECUTABLE = .*$/,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkgconf"].opt_bin}/pkg-config"

    # Fix find_package call using QtWebEngine version to find other Qt5 modules.
    inreplace lib.glob("cmake/Qt5WebEngine*/*Config.cmake"),
              " #{resource("qtwebengine").version} ", " #{version} "

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
    EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET    = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE  = app
      SOURCES  += main.cpp
    EOS

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
