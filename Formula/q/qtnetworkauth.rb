class Qtnetworkauth < Formula
  desc "Provides support for OAuth-based authorization to online services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtnetworkauth-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtnetworkauth-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtnetworkauth-everywhere-src-6.11.1.tar.xz"
  sha256 "9f1d5bf22ccc033e42076186b964f9d4d4179fd0312a2c0f1aa19db42516563d"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtnetworkauth.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd4080bac44121ac510ec81870a259a66ca1053cebe9707f4d9ac6c6e669dddf"
    sha256 cellar: :any,                 arm64_sequoia: "52767a785edc44dfa0a8228946b519f23e3fd9dae8a64d690c69a538e717254d"
    sha256 cellar: :any,                 arm64_sonoma:  "4cba74892fed5aaae20fbd7b9ddedc1c7eecb14abf32dde41ae8eefcb81071f6"
    sha256 cellar: :any,                 sonoma:        "fc65e6fedbd9f338be99f6e8a23c64d029f97c18c206aab545b857b9ac57e5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a266c0de33868dd0e2e3a57751f5cf10d060f3fdd33b180d3c45c962f4e964ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2015c3458a08a9fb812bf94a1ec3cf77f1b0d737c9ffb3a724763db2eac04c"
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
