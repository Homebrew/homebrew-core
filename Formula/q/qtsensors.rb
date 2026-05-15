class Qtsensors < Formula
  desc "Provides access to sensors via QML and C++ interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtsensors-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtsensors-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtsensors-everywhere-src-6.11.0.tar.xz"
  sha256 "412829258bc9f42766ed13a4b9d66604f184d349510b3248ec065cf90e1fc3c7"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtsensors.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ea2463f8474d8e777927138c3319d13dc288057618c3f8481bcec1da9636f70"
    sha256 cellar: :any,                 arm64_sequoia: "afe7493f7c9078fa51f3e51842bd8115d5baa64854afb285ff8bdb0b141bb7f0"
    sha256 cellar: :any,                 arm64_sonoma:  "3f5ca5f47de1f3c5c0e82c701e9a0da481bae4f0ab179ae387e647b94f6386d5"
    sha256 cellar: :any,                 sonoma:        "d2ce95fdeeaec00e92d06fd9e8b08e061d62a1cdbf7efa4b5e8ac1239085baa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed2843ec56d976a0f7936a325d3324d5f391d2e48a45797f0c2e2de38d9458e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509ed7f5f2e03ca5d2fa51ea0775d2b3ebe06ce4defd327d3b0228d622cfa3fe"
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
      find_package(Qt6 REQUIRED COMPONENTS Sensors)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Sensors)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += sensors
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QSensor>

      int main(void) {
        qDebug() << QSensor::sensorTypes();
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

    flags = shell_output("pkgconf --cflags --libs Qt6Sensors").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
