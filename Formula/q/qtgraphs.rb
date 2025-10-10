class Qtgraphs < Formula
  desc "Provides functionality for 2D and 3D graphs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtgraphs-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtgraphs-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtgraphs-everywhere-src-6.9.3.tar.xz"
  sha256 "50dc63d055125c30c0bf3a15dd1f71363e474f2fdcb35f927e754042440e048c"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtgraphs.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "842062cd5b5b9783204c54e38fc9dc0e946876bfe108a9ca87115212b8a47d97"
    sha256 cellar: :any,                 arm64_sequoia: "00e182933e70c234a022d5a2afaf6550df39fd7a3b9a17af0b6cc06e6dad9d31"
    sha256 cellar: :any,                 arm64_sonoma:  "b02ebfcc4f94c3ac10445b271b43fb36d31fc0dd93c7d8aa08862a2936727ada"
    sha256 cellar: :any,                 sonoma:        "7d4b370a336415cf30358bad0baf6e6054497ed77c3860a85abdbb66f1679e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180e3431696718ea0010ade945c930e16c1aa331027b6d3b9af4c36731cab5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8132f63315170949acea92ad6b5c39e6b593219f848455984ae5d7c33119e87b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on "qtshadertools"
  end

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
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
      find_package(Qt6 REQUIRED COMPONENTS Graphs)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Graphs)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += graphs
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QLineSeries>

      int main(void) {
        QLineSeries series;
        series.append(QList<QPointF>());
        series.append(0.0,0.0);
        series.append(QPointF());
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

    flags = shell_output("pkgconf --cflags --libs Qt6Graphs").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
