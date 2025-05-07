class QtWebengine < Formula
  include Language::Python::Virtualenv

  desc "Provides functionality for rendering regions of dynamic web content"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.0/submodules/qtwebengine-everywhere-src-6.9.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.0/submodules/qtwebengine-everywhere-src-6.9.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.0/submodules/qtwebengine-everywhere-src-6.9.0.tar.xz"
  sha256 "2b33d1c85e85ed58729db228448f92105ab746ffdc9b98f0c4e3bf00b789789e"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  # Chromium needs Xcode 15.3+ and using LLVM Clang is not supported on macOS
  # See https://bugreports.qt.io/browse/QTBUG-130922
  depends_on xcode: ["15.3", :build]

  depends_on "libpng"
  depends_on "qt"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "expat"
    depends_on "ffmpeg"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
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

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    # FIXME: GN requires clang in clangBasePath/bin
    inreplace "src/3rdparty/chromium/build/toolchain/apple/toolchain.gni",
              'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'

    # FIXME: See https://bugreports.qt.io/browse/QTBUG-89559
    # and https://codereview.qt-project.org/c/qt/qtbase/+/327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `/tmp` -> `/private/tmp`
    inreplace "src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_webengine_proprietary_codecs=ON
      -DFEATURE_webengine_kerberos=ON
    ]

    # Chromium always uses bundled libraries on macOS
    cmake_args += if OS.mac?
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      %W[
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0
      ]
    else
      # For arguments:
      # * The vendored copy of `libvpx` is used for VA-API hardware acceleration,
      #   see https://codereview.qt-project.org/c/qt/qtwebengine/+/454908
      # * The vendored copy of `re2` is used to avoid rebuilds with `re2` version
      #   bumps and due to frequent API incompatibilities in Qt's copy of Chromium
      # * As of Qt 6.6.0, webengine_ozone_x11 feature appears to be mandatory for Linux.
      %w[
        -DFEATURE_webengine_ozone_x11=ON
        -DFEATURE_webengine_system_alsa=ON
        -DFEATURE_webengine_system_ffmpeg=ON
        -DFEATURE_webengine_system_freetype=ON
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
      ]
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      # Some dependents' test use include path (e.g. `gecode` and `qwt`)
      include.install_symlink f/"Headers" => f.stem
    end
  end

  test do
    modules = ["WebEngineWidgets"]

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

    (testpath/"test.pro").write <<~QMAKE
      QT      += #{modules.join(" ").downcase}
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

      int main(int argc, char *argv[])
      {
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
    ENV["QTWEBENGINE_DISABLE_SANDBOX"] = "1"
    ENV.delete "CPATH" if OS.mac?

    system "cmake", "-S", ".", "-B", "cmake", "-DCMAKE_BUILD_RPATH=#{lib}"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    mkdir "qmake" do
      system Formula["qt"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end
