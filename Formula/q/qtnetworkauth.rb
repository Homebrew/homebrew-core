class Qtnetworkauth < Formula
  desc "Provides support for OAuth-based authorization to online services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtnetworkauth-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtnetworkauth-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtnetworkauth-everywhere-src-6.9.3.tar.xz"
  sha256 "67d9dc47ed133e22aa78bedef53963bee3761318e5e74dc98f82ad9814cc7ec7"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtnetworkauth.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab399edf6cc959b73a5efb50875654f815f49b46789f3f1554d191b34ed20a24"
    sha256 cellar: :any,                 arm64_sequoia: "5377a05fb0d37fd2a3ade99f81275728ec8a48af682da3a9cbb59f2986a83943"
    sha256 cellar: :any,                 arm64_sonoma:  "8d8ad5c1ebb1011236058ee0d21fe06f665010072a9f578e7ccc8b2a7fdbd62d"
    sha256 cellar: :any,                 sonoma:        "3c569735e684a5926c427b6afed07add72853779889a649d2f30c5215a077bf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d9cb0f09c8be38179c5098167c34466751869600c47d596435a1201c1354911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef5988a3cb2a31a2f2673aa4ade0d78512f681ef5350fd7fca1020b31f7e0be"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

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
      find_package(Qt6 REQUIRED COMPONENTS NetworkAuth)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::NetworkAuth)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += networkauth
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QHostAddress>
      #include <QOAuth2AuthorizationCodeFlow>
      #include <QOAuthHttpServerReplyHandler>

      int main(void) {
        QOAuth2AuthorizationCodeFlow oauth2;
        auto replyHandler = new QOAuthHttpServerReplyHandler(QHostAddress::Any, 1337);
        oauth2.setReplyHandler(replyHandler);
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

    flags = shell_output("pkgconf --cflags --libs Qt6NetworkAuth").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
