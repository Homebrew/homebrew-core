class Qtwebengine < Formula
  include Language::Python::Virtualenv

  desc "Provides functionality for rendering regions of dynamic web content"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtwebengine-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtwebengine-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtwebengine-everywhere-src-6.9.3.tar.xz"
  sha256 "d50b3b11d51dd876418cc36b4d6c96b4721e0aab773a3dd6beda606d46da8966"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qwebengine_convert_dict; QtWebEngineProcess
    "BSD-3-Clause", # *.cmake; main Chromium license

    # The following extra licenses are for Chromium's bundled libraries
    # https://doc.qt.io/qt-6/qtwebengine-licensing.html#third-party-licenses
    "Apache-2.0",        # Abseil; Crashpad; FlatBuffers; libgav1; ...
    "blessing",          # sqlite
    "BSD-2-Clause",      # aom; cpuinfo; dav1d; libavif
    "LGPL-2.1-or-later", # ffmpeg (macOS); speech-dispatcher (Linux)
    "libpng-2.0",        # libpng (macOS)
    "MIT",               # Brotli; CityHash; FP16; fast_float; ...
    "MPL-1.1",           # hunspell
    "NCL",               # PFFFT
    "SGI-B-2.0",         # mesa_headers
    "SunPro",            # fdlibm
    "Zlib",              # zlib (macOS)
    :public_domain,      # sigslot; SPL-SQRT-FLOOR
    { all_of: ["ISC", "OpenSSL"] }, # boringssl, TODO: remove in Chromium 134+
  ]
  revision 2
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2b33693880d5f39fdf14d0ae2fe7ec5c6323abbfafd87811835346721bb92f7"
    sha256 cellar: :any,                 arm64_sequoia: "c070fc963c104f269dfb20f455cbd794c9d417f01bf97cecfd5851d6245f9fdc"
    sha256 cellar: :any,                 arm64_sonoma:  "59a1fb591eb38483ae28745d55c44487aacddb7f72e6d07e9b52eeb4be1ec92e"
    sha256 cellar: :any,                 sonoma:        "4e60080db2a07566af88221d4c6b5c3b3a8865150799428e7d1de2098f278901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603b05035c86c3d10b0e94f724e76e2dfd3cd3b33e227f1bd0061b21dd602f7b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "qttools" => :build
  # Chromium needs Xcode 15.3+ and using LLVM Clang is not supported on macOS
  # See https://bugreports.qt.io/browse/QTBUG-130922
  depends_on xcode: ["15.3", :build] # for metal and xcodebuild

  depends_on "libpng"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtpositioning"
  depends_on "qtwebchannel"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "krb5" # dlopen-ed in http_auth_gssapi_posix.cc
  uses_from_macos "zlib"

  on_macos do
    depends_on "qttools"
  end

  on_linux do
    depends_on "libva" => :build
    depends_on "libxcursor" => :build
    depends_on "libxi" => :build
    depends_on "libxshmfence" => :build
    depends_on "pulseaudio" => :build
    depends_on "xorgproto" => :build

    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "expat"
    depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@78"
    depends_on "jpeg-turbo"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libtiff"
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
    depends_on "snappy"
    depends_on "systemd"
    depends_on "webp"
  end

  pypi_packages package_name:   "",
                extra_packages: "html5lib"

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Apply Fedora's upstreamed patch to support Python 3.14+
    # Ref: https://github.com/html5lib/html5lib-python/pull/583
    # Ref: https://src.fedoraproject.org/rpms/python-html5lib/blob/rawhide/f/583.patch
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/379f9476c2a5ee370cd7ec856ee9092cace88499.patch?full_index=1"
      sha256 "97ae2474704eedf72dc5d5c46ad86e2144c10022ea950cb1c42a9ad894705014"
    end
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    # Kill run early to avoid timing out and skipping dependent tests for Qt version bumps
    # FIXME: Remove when we add a self-hosted runner and automatically handle via labels
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    odie "Unable to build on GitHub-hosted arm64 Linux runner!" if github_arm64_linux

    python3 = "python3.14"
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Allow -march options to be passed through as Chromium builds runtime
    # detected code and arm64 compilation will fail if shim removes -march
    ENV.runtime_cpu_detection

    # Work around GN requiring clang in clangBasePath/bin
    inreplace "src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
              'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_webengine_proprietary_codecs=ON
      -DFEATURE_webengine_kerberos=ON
      -DNinja_EXECUTABLE=#{which("ninja")}
    ]

    # Chromium always uses bundled libraries on macOS
    args += if OS.mac?
      # Cannot deploy to version later than 14, due to functions obsoleted in macOS 15.0
      # https://bugreports.qt.io/browse/QTBUG-128900
      deploy = [MacOS.version, MacOSVersion.from_symbol(:sonoma)].min

      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{deploy}.0
        -DFEATURE_webengine_native_spellchecker=ON
        -DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON
      ]
    else
      # The vendored copy of `libvpx` is required for VA-API hardware acceleration,
      # see https://codereview.qt-project.org/c/qt/qtwebengine/+/454908
      #
      # The vendored copy of `re2` is used to avoid rebuilds with `re2` version
      # bumps and due to frequent API incompatibilities in Qt's copy of Chromium.
      %w[
        -DFEATURE_webengine_ozone_x11=ON
        -DFEATURE_webengine_system_alsa=ON
        -DFEATURE_webengine_system_ffmpeg=ON
        -DFEATURE_webengine_system_freetype=ON
        -DFEATURE_webengine_system_gbm=ON
        -DFEATURE_webengine_system_harfbuzz=ON
        -DFEATURE_webengine_system_icu=ON
        -DFEATURE_webengine_system_lcms2=ON
        -DFEATURE_webengine_system_libevent=ON
        -DFEATURE_webengine_system_libjpeg=ON
        -DFEATURE_webengine_system_libpng=ON
        -DFEATURE_webengine_system_libxml=ON
        -DFEATURE_webengine_system_libwebp=ON
        -DFEATURE_webengine_system_minizip=ON
        -DFEATURE_webengine_system_opus=ON
        -DFEATURE_webengine_system_pulseaudio=ON
        -DFEATURE_webengine_system_snappy=ON
        -DFEATURE_webengine_system_zlib=ON
        -DFEATURE_webengine_vaapi=ON
      ]
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS WebEngineWidgets)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebEngineWidgets)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += webenginewidgets
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <QApplication>
      #include <QTimer>
      #include <QWebEngineView>

      int main(int argc, char *argv[]) {
        QApplication app(argc, argv);
        QWebEngineView view;
        view.setUrl(QUrl(QStringLiteral("https://brew.sh/")));
        view.show();
        QTimer::singleShot(2000, &app, SLOT(quit()));
        return app.exec();
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    ENV.delete "CPATH" if OS.mac?

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6WebEngineWidgets").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
