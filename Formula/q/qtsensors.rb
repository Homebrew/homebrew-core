class Qtsensors < Formula
  desc "Provides access to sensors via QML and C++ interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtsensors-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtsensors-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtsensors-everywhere-src-6.11.1.tar.xz"
  sha256 "23617062da7be526d023dec7f9b76231001a1098a7e5f94c646f2e4f87cfcf8f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a5c7f669f591e40ea7c7926e8e084fdff4799dcd71b9a019d7ebda9e4100f22c"
    sha256 cellar: :any,                 arm64_sequoia: "91cf5868f2d44f0e88631a7c0dfdf1e424a33443db21b8f43a25dc0ba38eff48"
    sha256 cellar: :any,                 arm64_sonoma:  "727c08c9cef9d7d75a7d3e954f45ddd3bfaf693bb4b97374646dab3197e90dd2"
    sha256 cellar: :any,                 sonoma:        "dc84bf91a29c82666d75d1470abe88e5e3b52dee5cedce17c1cfaf21aa90977a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0812242d8e0a45764207e7e77e0df0716428d44c2e1461eb053a4e4f184b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c53fd946ac5c43d071097b7aec6be4849e3ee0e7b9877d0bc3ef2adc5c23529"
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
