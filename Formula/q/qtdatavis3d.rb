class Qtdatavis3d < Formula
  desc "Provides functionality for 3D visualization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtdatavis3d-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtdatavis3d-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtdatavis3d-everywhere-src-6.10.2.tar.xz"
  sha256 "b769408bf4a3d03220331d5de59636fdf97a21831d01d3fd141c36c698355bc1"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtdatavis3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32346fdbccc25a6e102599876016c5a9a47dfb4d75cb592d6693ffef2355fd1b"
    sha256 cellar: :any,                 arm64_sequoia: "c7000be28b5fc0a3f51e109289e32324b4d429c24be67b440aaba1dbfcd4bfe0"
    sha256 cellar: :any,                 arm64_sonoma:  "01f38b7b7b7a5d35b9f6fd1fcdc15e5de268b5b3b199fa5533afbb6ffd19521f"
    sha256 cellar: :any,                 sonoma:        "d48d21cc0425467f736489ddaa29db17226ec1f917fd19d8819373335e6b4e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dbfe61013000fa1b2bf2dedd3d5ebf1e5a0ba7f5ffdbd283906cfa688440ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fe8ed1d453262b7ca797ea67e8c75acd938ae2b8ba0450b717e2796ce0237cc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

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
      find_package(Qt6 REQUIRED COMPONENTS DataVisualization)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::DataVisualization)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += datavisualization
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtDataVisualization>

      int main(void) {
        QBar3DSeries series;
        QBarDataRow *data = new QBarDataRow;
        *data << -1.0f << 3.0f << 7.5f << 5.0f << 2.2f;
        series.dataProxy()->addRow(data);
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

    flags = shell_output("pkgconf --cflags --libs Qt6DataVisualization").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
