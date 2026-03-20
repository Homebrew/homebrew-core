class Qtquick3d < Formula
  desc "Provides a high-level API for creating 3D content or UIs based on Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtquick3d-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtquick3d-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtquick3d-everywhere-src-6.10.2.tar.xz"
  sha256 "b95439f31d1e580c379e9828b48b03b932b0bdade4ff09f4dd639eff9da2cd75"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "Apache-2.0",   # bundled embree; bundled openxr
    "BSD-3-Clause", # bundled tinyexr; *.cmake
    "MIT",          # bundled jsoncpp
  ]
  head "https://code.qt.io/qt/qtquick3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d863a2d7d5d373157aa904fe02bfb3077913c2e1176f2f5cb3d5786e5628042b"
    sha256 cellar: :any,                 arm64_sequoia: "4e4f10e2a89c7d3f0f4c3ceabc4274416da7e1d3e2bfc476dd72f19c262ae951"
    sha256 cellar: :any,                 arm64_sonoma:  "034701ea502e02b54810a34f60a37a8d80a8f4bcaf1b926fd3ce94ab72675f1d"
    sha256 cellar: :any,                 sonoma:        "0af25cc2cd2bac945cde48583d4cd6ffb596c0da0ccd9c134cccf5852ac73fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ed7e0d6115952e2efaa9a4a03e8703abfc952b615fb09a07a2a2a3a62ae3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70705e25dff7508d25e29dc509b68a09da48f261cd75cbe553df6075725fe5e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "vulkan-headers" => :build
  depends_on "pkgconf" => :test

  depends_on "assimp"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquicktimeline"
  depends_on "qtshadertools"

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  # Apply Arch Linux patches for assimp 6 support
  # Issue ref: https://bugreports.qt.io/browse/QTBUG-137996
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-quick3d/-/raw/2c6f918ee81adb61290cf56453c2d67e5dce259f/assimp-6.patch"
    sha256 "573f00cdad90d77786fba80066d61d5ee97fc56a8b11d0896949acd16bda8e91"
  end

  def install
    rm_r("src/3rdparty/assimp")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_system_assimp=ON
    ]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

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
      find_package(Qt6 REQUIRED COMPONENTS Quick3D)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Quick3D)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += quick3d
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QGuiApplication>
      #include <QQuick3D>
      #include <QSurfaceFormat>

      int main(int argc, char *argv[]) {
        QGuiApplication app(argc, argv);
        QSurfaceFormat::setDefaultFormat(QQuick3D::idealSurfaceFormat(4));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Quick3D").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
