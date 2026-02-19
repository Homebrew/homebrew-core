class Qtwebsockets < Formula
  desc "Provides WebSocket communication compliant with RFC 6455"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwebsockets-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtwebsockets-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtwebsockets-everywhere-src-6.10.2.tar.xz"
  sha256 "eccc751bea509ef656d20029693987a0fc03c58e21c38f1351480f3c8eb42ebd"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebsockets.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d23374faec1795881289c3fba3e59b6491eb3148363947981270618cf7b50cf"
    sha256 cellar: :any,                 arm64_sequoia: "436c91afc9a22f35b540c7b99aaf141b43be7156ad9a422ede2aafdece03c3c2"
    sha256 cellar: :any,                 arm64_sonoma:  "5952c3bddbbbe4a3e9a6312383853715fe1b72084152a0f498c9b3d6db672364"
    sha256 cellar: :any,                 sonoma:        "2c112d929561f275d812b338027e4a80d11f458722b8e328b4c7ac84dd49da1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de1229f5f4519be6ecae4d2c6df9b3a8c47fcfcc0179684d51c0b6b06734bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e635e01a244a34dbe17a91306c4bd8776ca6c2899898e5dbee588002dc57fdb"
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
