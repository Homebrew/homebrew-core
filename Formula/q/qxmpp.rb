class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.6/qxmpp-v1.14.6.tar.bz2"
  sha256 "4de36733f43c1b65a27c6803ea631d4bbfc84793b6d7c73fd0b97d39179e33df"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0922edbdc9cc8f5c0b631e834e83b13548472146daf3369c185750e01cf329ac"
    sha256 cellar: :any,                 arm64_sequoia: "d1913cfbb03c5789062a93d647a5b575006d5524b6de5fb43d87a5c2dafc5d47"
    sha256 cellar: :any,                 arm64_sonoma:  "2314c93609a9ceac4fe1a5c6650248f20c0c98864de8f970f71693d4cf527a27"
    sha256 cellar: :any,                 sonoma:        "8b1ce7b4eee1d76eafec03afb635db0a304157d580c6aeb8aada294d78051160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52215db44aa602ab3c946a2db15514e80652f8db35b52f7e1a362ffe88a21fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4d53617da05dea81749cb1df12b4ae771326aa874e8e91530e93ebe7779e95"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~QMAKE
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
