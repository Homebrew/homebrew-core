class Qtquick3d < Formula
  desc "Provides a high-level API for creating 3D content or UIs based on Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtquick3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtquick3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtquick3d-everywhere-src-6.9.3.tar.xz"
  sha256 "91b270049f38ad2b7370c2e6edc72c19ed7d5d2281d914457586f29daccace73"
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
    sha256 cellar: :any,                 arm64_tahoe:   "79885a388c2b7f028a61e79edd28fa996cf0a0da9b65e2ed5cf04c620baec428"
    sha256 cellar: :any,                 arm64_sequoia: "53d5d526f7c5cbfc00784c394d79c9ee0116956c6be33ecb0d5e6709638184ca"
    sha256 cellar: :any,                 arm64_sonoma:  "4ef0671faa485029e32512124fa6d03fcfa27bc3eead1fde5023699abeaac622"
    sha256 cellar: :any,                 sonoma:        "afbcecc705bd9163dfb28a1b87249ff8301f5e09fa8b9c9a9f7bcf2ffef7cd78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "217ed5235e03f772a6531a333f10f1da3ca88a2f6c0081bf649d080758a51882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b559aa384660f248f828ddf6cdcc96e43470468e43620735a2e28ee15a6575"
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

  uses_from_macos "zlib"

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
