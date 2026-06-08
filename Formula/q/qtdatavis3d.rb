class Qtdatavis3d < Formula
  desc "Provides functionality for 3D visualization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtdatavis3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtdatavis3d-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtdatavis3d-everywhere-src-6.11.1.tar.xz"
  sha256 "1e1a7b9c0a947731655334f5d79252d40cdaf58c1801074ea5e9e0821d6693ac"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtdatavis3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "542be0af66d64d482edc83fe1da954bd59acc8c67b1f8181fc6fa0de949734b3"
    sha256 cellar: :any,                 arm64_sequoia: "a9fd9c5c85ae4b5b61c724e8ed32850a0e481d6f6239a05f72b54f09b9f17f76"
    sha256 cellar: :any,                 arm64_sonoma:  "4c2b7726e1952360e7b93cec2c889bc4bbf8f91c6df4c9cf261d7869c0406700"
    sha256 cellar: :any,                 sonoma:        "f8baa23c09d209cc91c618e3fa057b608033fdb67e419192a38c81a29002f622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dcc457db32203a4cdb85dc42683016b2f09df3cae98701719dd3673de9d2612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "286e7e62122c323a69ba693b2f5b3d492440a690c249e0ef3e1e0bcefe6fc403"
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
