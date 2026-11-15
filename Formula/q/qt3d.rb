class Qt3d < Formula
  desc "Provides functionality for near-realtime simulation systems"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qt3d-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qt3d-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qt3d-everywhere-src-6.12.0.tar.xz"
  sha256 "d16f7489945c6c9e971cedd4362202a2681f3c10393461e1f5e74425f7fef59a"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
    "MIT", # bundled imgui
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ea8a51b7c696adba02f1be4e5c4e84b44965416e29e5a619516153c562f54813"
    sha256 cellar: :any, arm64_tahoe:       "0ab93fd0a6448735eeb72d8bbc6c1d1c9e962dbcc2c2b4206d0986e798a04bc7"
    sha256 cellar: :any, arm64_sequoia:     "fe7c4a922801af5a658764e45f97a785bc1d8ec597efbe268db2f61d88909500"
    sha256 cellar: :any, arm64_linux:       "26af039492dd460fdc35e1e8c8aff5d9fb3c03b48ec1427f2f76ce4900c2c275"
    sha256 cellar: :any, x86_64_linux:      "c7d3d305868ab95e2686c6b090fd61d7814d577ed8c1c6c6dcaf2fd6e4b929d5"
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

  conflicts_with "qt@5", because: "both link conflicting binaries"

  # Apply Arch Linux patches for assimp 6 support
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-3d/-/raw/811dd8b18b4042f7120722b63953499830b51ddd/assimp-6.patch"
    sha256 "244589b0a353da757d61ce6b86d4fcf2fc8c11e9c0d9c5b109180cec9273055a"
    type :unofficial
    resolves "https://bugreports.qt.io/browse/QTBUG-137996"
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
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
