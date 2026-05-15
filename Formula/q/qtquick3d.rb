class Qtquick3d < Formula
  desc "Provides a high-level API for creating 3D content or UIs based on Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtquick3d-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtquick3d-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtquick3d-everywhere-src-6.11.0.tar.xz"
  sha256 "b42000bb33e55b6c642657eb7022ee1f74f9e19cf64d52e85d41763f567b8994"
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
    sha256 cellar: :any,                 arm64_tahoe:   "73418fb9b87b32eb0a023444dbdffb300f2693113ccfc35ac7066913bd26a23c"
    sha256 cellar: :any,                 arm64_sequoia: "867b9f043b71f9abca68ff781771067f2df3356cfc1c9a81f4b52b2bf81756ab"
    sha256 cellar: :any,                 arm64_sonoma:  "d1e4e45d4e49b6ea439d818ec3b8b7e68cdfad000fae363de51a1ad97f1f9942"
    sha256 cellar: :any,                 sonoma:        "c357ea4c7dd50bd1e832e15ea8f6d4fc1084fc102963c32a6cac2c83a3c40f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e346d06fddd35c73d9a6681c15b164084cae119776f876cc337e338a80a29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f73138796fcd0020728eab4e85642ff62e3b693bec22bd423650266a7d5903"
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
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-quick3d/-/raw/547cb929d0a03fdf817fdf2655629bcb9b75505d/assimp-6.patch"
    sha256 "394b5f26877477c4ceba252c06a6a2101f5e99e3dddc01cc8831e7fa7d70f797"
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
