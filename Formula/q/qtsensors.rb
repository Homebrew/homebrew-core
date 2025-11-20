class Qtsensors < Formula
  desc "Provides access to sensors via QML and C++ interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtsensors-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtsensors-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtsensors-everywhere-src-6.9.3.tar.xz"
  sha256 "a2db5168e5f37631a4ad087deaed69abdfa0be6d182f56e8604764658df92f68"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtsensors.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dca45295912da2383cad2f3e6779ed2aa96ff664699f195a12eec0f125352bdd"
    sha256 cellar: :any,                 arm64_sequoia: "5b6bdfc6f3a672609e24dfd8e2d71b204583f8a71418a422d220cb2fd8ce690c"
    sha256 cellar: :any,                 arm64_sonoma:  "1635586cca09a521c0ee68324e21b3bf85ae9f37a9f5a146fc79cd7edf740afd"
    sha256 cellar: :any,                 sonoma:        "465beb97f05da8f693c3e84489142261c93b9c7bc4aa2d291f3132614ecbffe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af92409ff64662bf3b4884b244b86be5bd1e25e73e065b50a139f4cfb42779f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0693ae7ee4d158061579435e40cc4c012984ab7ec61a0ac1817819dde01117f7"
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
