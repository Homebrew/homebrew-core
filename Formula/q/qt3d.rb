class Qt3d < Formula
  desc "Provides functionality for near-realtime simulation systems"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qt3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qt3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qt3d-everywhere-src-6.11.1.tar.xz"
  sha256 "a66d8c8e049d1ee7a7687b34940f3555d0d7084858b6dc78d1e1cb7df40a0107"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
    "MIT", # bundled imgui
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a18a782e5e6f486e116b88dc23cc66eb910d2bd7ab9ea25cb11912b5e185fa7"
    sha256 cellar: :any,                 arm64_sequoia: "75873e5eac56e88a6c3a3ed3fadd511065b1ca2de515255b8d45a85e5b72e2ce"
    sha256 cellar: :any,                 arm64_sonoma:  "51e67b7fe51761238c77134b6e509ed826996cba3c6fa5ed17deff3a18ba49a1"
    sha256 cellar: :any,                 sonoma:        "2aaf3048d361b830c3fcd42b188642c2c00c5fe6794949d1a14db5014e1e1416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791b22c9652c207f8a2746c622a7e2f62d1f44c06a13e9b6e3979b041d46242f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "377731b1dd5fb6456a1dca865f045cff97ffa035b635c23bff9054586ec40da9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "vulkan-headers" => :build
  depends_on "vulkan-loader" => :build
  depends_on "pkgconf" => :test

  depends_on "assimp"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtshadertools"

  # Apply Arch Linux patches for assimp 6 support
  # Issue ref: https://bugreports.qt.io/browse/QTBUG-137996
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-3d/-/raw/811dd8b18b4042f7120722b63953499830b51ddd/assimp-6.patch"
    sha256 "244589b0a353da757d61ce6b86d4fcf2fc8c11e9c0d9c5b109180cec9273055a"
  end

  def install
    rm_r("src/3rdparty/assimp/src")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_qt3d_system_assimp=ON
      -DFEATURE_qt3d_vulkan=ON
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
    modules = %w[3DCore 3DRender 3DInput 3DLogic 3DExtras 3DAnimation]

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
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
      #undef QT_NO_DEBUG
      #include <Qt3DCore>
      #include <Qt3DExtras>

      int main(void) {
        Qt3DCore::QEntity *rootEntity = new Qt3DCore::QEntity;
        Qt3DCore::QEntity *torusEntity = new Qt3DCore::QEntity(rootEntity);
        Qt3DExtras::QTorusMesh *torusMesh = new Qt3DExtras::QTorusMesh;
        torusMesh->setRadius(5);
        torusMesh->setMinorRadius(1);
        torusMesh->setRings(100);
        torusMesh->setSlices(20);
        delete torusMesh;
        delete torusEntity;
        delete rootEntity;
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

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
