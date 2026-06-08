class Qtwebchannel < Formula
  desc "Bridges the gap between Qt applications and HTML/JavaScript"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtwebchannel-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtwebchannel-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtwebchannel-everywhere-src-6.11.1.tar.xz"
  sha256 "69fbb50b71d6e6596c2d6863ee9a9c984a4d01378ee2b7b4163bb467a0158d82"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebchannel.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9499b5be92b9cdd93f092ac33c4dc770c0b6f2e7e5bc93dad9f24bc0616ae72d"
    sha256 cellar: :any,                 arm64_sequoia: "b68ea00185ef00cb3c8758a9120b24338f6378d9cb4db79170302de99a06a8f1"
    sha256 cellar: :any,                 arm64_sonoma:  "bc73ae22253b9deaf0702c0d5b8a2438a2dc0a28d53b44e925176220a03b6614"
    sha256 cellar: :any,                 sonoma:        "56c8253297a320f4d2785b0796d3f28276cda7201c320be3652963b3850866e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b308f94268ad7eb868b0055c6271860c19c1573f5755916f7ca0b0aafe2c034a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9266b8239f5a8495a3db9a83f1452aec6696a2aeeb6034d669a614602fda1c1a"
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
      find_package(Qt6 REQUIRED COMPONENTS WebChannel)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebChannel)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += webchannel
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QHash>
      #include <QObject>
      #include <QString>
      #include <QStringLiteral>
      #include <QWebChannel>

      int main(void) {
        QWebChannel channel;
        QObject plain;
        QHash<QString, QObject*> objects;
        objects[QStringLiteral("plain")] = &plain;
        objects[QStringLiteral("channel")] = &channel;
        channel.registerObjects(objects);
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

    flags = shell_output("pkgconf --cflags --libs Qt6WebChannel").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
