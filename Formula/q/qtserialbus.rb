class Qtserialbus < Formula
  desc "Provides access to serial industrial bus interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtserialbus-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtserialbus-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtserialbus-everywhere-src-6.10.2.tar.xz"
  sha256 "4736bffecfb6940ebd7aeae260a7ac2c68da979bdf9153c2b59dcafa40793a7b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "25ff906e3b32b6a31d9c41e529adf29df0f7b7abd6b81742e77a0315227b9962"
    sha256 cellar: :any,                 arm64_sequoia: "e8ad71c15e08ce8769dc52b4eb25272f8d9010104f1ee897cb04558c36741c41"
    sha256 cellar: :any,                 arm64_sonoma:  "c2eb256a4116b197067601099149fcaf97322b89cb580ecb65e5669740ca7e11"
    sha256 cellar: :any,                 sonoma:        "3c6c0db4d3fb4aeed022aa9e8a5c5432242064d5611ce987f25acd30f9d27631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5caacca1e6ee9a5d741952a76020c2613e5fa80e60720ae125ddd80bef1de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33235a308a6d116a502a9476f70342b4ee41233b8425b13811e4e96f5e31818"
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
