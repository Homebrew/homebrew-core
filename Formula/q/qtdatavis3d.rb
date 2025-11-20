class Qtdatavis3d < Formula
  desc "Provides functionality for 3D visualization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtdatavis3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtdatavis3d-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtdatavis3d-everywhere-src-6.9.3.tar.xz"
  sha256 "aa4b45b896a629a1bc5ebbb7990086b5d52d0ab9fabc996dd047a27f256fbfec"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtdatavis3d.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0c88a3975ea69bafab13c3c009019d61d15ea68bab813fc79a6936f0ba8aeb7"
    sha256 cellar: :any,                 arm64_sequoia: "048fb1a7ca21911b673b60cfab84ffe5b1df0e456074c3d2ae0931c6082d782b"
    sha256 cellar: :any,                 arm64_sonoma:  "0f775673261ecc87fa57013deca8507e97c9f4460f3292fa8bd9d269535ae747"
    sha256 cellar: :any,                 sonoma:        "d93635c60a9b4748fb72d17cc7ff1e340656967a0bcfa61083404813d472f4b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe73f58cae95e31b26674b9a2090efb1f53958ce69a23df4fdf8a1746a2f03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb1f8259a9425da6ea8f22654c6226f5382f7be12e8b37c2e5f5bf9bd41752e"
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
