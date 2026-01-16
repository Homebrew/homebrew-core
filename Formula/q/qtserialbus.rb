class Qtserialbus < Formula
  desc "Provides access to serial industrial bus interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtserialbus-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtserialbus-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtserialbus-everywhere-src-6.10.1.tar.xz"
  sha256 "2539fcf77af2dfa59756338e0c44d491995eb2576f9a288fa4888efd9eab3ed5"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # canbusutil
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtserialbus.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d78c8fc9e7bc8419bc22c167947a7b3e319971d07ed5099b16efe313eacb8786"
    sha256 cellar: :any,                 arm64_sequoia: "914c05ddf480dc35eab4679d1d36e83cea6411fd57388ba5100cc59fa654aaf6"
    sha256 cellar: :any,                 arm64_sonoma:  "dd9595c3a751d32b21f362e024b7cbc668332c0c947fe43b0163899374726131"
    sha256 cellar: :any,                 sonoma:        "7eef07a5893a3935a9bb41ad778ded01d6ccee47a8ae0d1c4e2c0041ece34eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2cf6edcf384e8e91c4281a84dc72a3fef0e7eea1e28e55085ede116df70b2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52df1e698c28a1d3acace49b0b3dd15c2e7855c1c35db8386cc38afda932d4d1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtserialport"

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
      find_package(Qt6 REQUIRED COMPONENTS SerialBus)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::SerialBus)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += serialbus
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QCanBus>
      #include <QDebug>

      int main(void) {
        // NOTE: Can safely ignore "Cannot load library" as it checks for proprietary drivers
        for (auto device : QCanBus::instance()->availableDevices()) {
          qDebug() << device.name();
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6SerialBus").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
