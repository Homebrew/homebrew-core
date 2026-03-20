class Qthttpserver < Formula
  desc "Framework for embedding an HTTP server into a Qt application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qthttpserver-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qthttpserver-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qthttpserver-everywhere-src-6.10.2.tar.xz"
  sha256 "26568d59bee258fd35297823d2f7839ef1337042a009b752769e688703fe4643"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qthttpserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9444fed74dd9a015454f644e500b9b680b8795e794aa54bebe9ba0790872299c"
    sha256 cellar: :any,                 arm64_sequoia: "02faa6ad129198c43524801f028ee357a13b078075baecd6b657eaf20c64e300"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d858e6b53457ad6dd3599b594ec6c456f6afafbddb81e05bf32055804134ea"
    sha256 cellar: :any,                 sonoma:        "ee13e6d45abee802d25e7f7d2e370789e14f88691fc96a9bc0109b829fb56b0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3237dc5127e8c7a2723c0623d69dc6e31d34023dc0a8eb5d48477015353938d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5eb46ed499b539b359ad42cbc95b83d9e62e9743a66f92f5183e43a799d335"
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
