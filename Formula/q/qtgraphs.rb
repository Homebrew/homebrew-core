class Qtgraphs < Formula
  desc "Provides functionality for 2D and 3D graphs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtgraphs-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtgraphs-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtgraphs-everywhere-src-6.10.2.tar.xz"
  sha256 "f690fc6aa567d89a6e76ce370d684beb243dc0c2ed1187dd305433e278dd7aaf"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtgraphs.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37bff1366be3ccc926450e6cd8fea4ad9f8228ae8defcb4b0509a1ec97ef5d2c"
    sha256 cellar: :any,                 arm64_sequoia: "1b3b3d438c21799d3fc1a723bb0290e687ce2c0f6e567009ae0eaaacd336b3f6"
    sha256 cellar: :any,                 arm64_sonoma:  "ec1dcc996416be18f018787c83de2458bf4893c95f64e6305c164490df4dc097"
    sha256 cellar: :any,                 sonoma:        "35b440995dbd5a999fda2ae650b7f092ceaf325d6bf9b8e67736e465afb50a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "532d2fd7b91c139e83bbefb29904ebc2d1863971a967ead62d282808f17cd832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a319728401c293c0efc8425b88c08b3ea5c1b5b8e29128fdb7f332f1a45c195"
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
