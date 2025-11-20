class Qthttpserver < Formula
  desc "Framework for embedding an HTTP server into a Qt application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qthttpserver-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qthttpserver-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qthttpserver-everywhere-src-6.9.3.tar.xz"
  sha256 "7aa78793dba5cfb81a1d1e4b840bf0faf1e31beea08945b5689f404160dd2e8f"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qthttpserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e0fe1076f314ddb05b1a90e1d503fc75e4791edb9f2dad4a6e9ce68a6893369"
    sha256 cellar: :any,                 arm64_sequoia: "00448db412835a0cbf5122710eb850691d623e684bbeebdd29b8453455d1871e"
    sha256 cellar: :any,                 arm64_sonoma:  "21021f558680347f1d8eb095da082e1493841578f3d8ad0e9d1b4f5a48f0901c"
    sha256 cellar: :any,                 sonoma:        "e1ada1a98da0ea43fa4132be5fb312dfc492adfbd8e2385d0fd8a6ddae320afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035ab1808fdd1405de0d238dfe15ae2a2131bb5db2485a64c7331f3cfc653125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d1ce8ddcb81a5820e6a2598c314a026a80487a4c577babc0c94ee4cc5a436b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtwebsockets"

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
      find_package(Qt6 REQUIRED COMPONENTS HttpServer)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::HttpServer)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += httpserver
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtHttpServer>

      int main(void) {
        QHttpServer httpServer;
        httpServer.route("/", []() { return "Hello world"; });
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

    flags = shell_output("pkgconf --cflags --libs Qt6HttpServer").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
