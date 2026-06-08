class Qtwebsockets < Formula
  desc "Provides WebSocket communication compliant with RFC 6455"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtwebsockets-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtwebsockets-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtwebsockets-everywhere-src-6.11.1.tar.xz"
  sha256 "243e3aa11924c8c5c1645e892f62d013caa3766c57512ca926d5b58146646fbf"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebsockets.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "515b1fffe664d577880912a557abdb489a6594fb543f36d8a12c4ed4b7dca55f"
    sha256 cellar: :any,                 arm64_sequoia: "69cfe6ad85a6d7a9d8a60020e67e677cd056b56bd9d4b91dd224b3e0dc17295d"
    sha256 cellar: :any,                 arm64_sonoma:  "537548ae9ef5e66b0a8272228adc81b38939afafec50a96d0569493a3df31009"
    sha256 cellar: :any,                 sonoma:        "c1d7ba997215e62a49fa97083f5837a77fce55ce5640a57565236c1e6125a64a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd66e3f95b57197153eff9f3ae19d0f2affcea894ca3a414720e14cb307bd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "489733730581cef17bc4204fe5a7d523310424428f7bb1545dedaf7d7a096ead"
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
      find_package(Qt6 REQUIRED COMPONENTS WebSockets)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebSockets)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += websockets
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtWebSockets>

      int main(void) {
        QWebSocketServer server{QStringLiteral("Test Server"), QWebSocketServer::NonSecureMode};
        Q_ASSERT(server.listen(QHostAddress::Any, #{free_port}));
        server.close();
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

    flags = shell_output("pkgconf --cflags --libs Qt6WebSockets").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
