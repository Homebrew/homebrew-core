class Qt3d < Formula
  desc "Provides functionality for near-realtime simulation systems"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qt3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qt3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qt3d-everywhere-src-6.9.3.tar.xz"
  sha256 "7e8664ddf21a79d4eeaebf76dddf017ed31142a2df005cf4ac784dff10627fff"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
    "MIT", # bundled imgui
  ]
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7c4070b5517cc9d66832b3f9f86a128552326891b12a1d0305a45863a215b559"
    sha256 cellar: :any,                 arm64_sequoia: "f5eadd6340ec9eaff1fe237276ac1c96d92d00418781ce0193c54513ccb86794"
    sha256 cellar: :any,                 arm64_sonoma:  "65a561bf7e4b9c141f098989d559b52774f7f333cddc278bcf491a1fd9bc2a8e"
    sha256 cellar: :any,                 sonoma:        "67afad57e2f2d4a670ccd11ca69b605c98f6667a45fcda1cce8bada408ce8418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9d9961e488ac949eede9654228e1785304b592ba3077479ad06e6bcade7ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cf1968db2f3e0b069b819de7666edc18283d45623c9df19156659f3490d91e"
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
