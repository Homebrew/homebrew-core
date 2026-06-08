class Qtquick3d < Formula
  desc "Provides a high-level API for creating 3D content or UIs based on Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtquick3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtquick3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtquick3d-everywhere-src-6.11.1.tar.xz"
  sha256 "c76b85de3f8aa2a4bee64987acfef560675c1b378b92076c7c6264613e5b456f"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "Apache-2.0",   # bundled embree; bundled openxr
    "BSD-3-Clause", # bundled tinyexr; *.cmake
    "MIT",          # bundled jsoncpp
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquick3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f249aa6a9a60893be5c4cb19576b2dc6a8c7c30ec479a13b2b257590c744194"
    sha256 cellar: :any,                 arm64_sequoia: "0ab350097696b313eed8cf3ffd62af16ee2bfc46196db047a6e8b118f5ea06e7"
    sha256 cellar: :any,                 arm64_sonoma:  "1f3f1c768e3eeab12892d85713dd98b02f38dc788a2b43fa16138dc1236fd32b"
    sha256 cellar: :any,                 sonoma:        "9141d684fdce3b159e85e9c814afd4b9aafe5d6c439c2586270dd804df226993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec342bca633378b2365581dd6c100c27ee8b757728642b202dc96ef41a48740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07bdc05f4421d68892a559350204b03681b22f7b0a69e2ac2cbd75ebbf1190b0"
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
