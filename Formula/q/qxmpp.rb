class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.11.3/qxmpp-v1.11.3.tar.bz2"
  sha256 "afa01989d80d06c377b91af82cd951b8bdf568e6f8f76b9446756d99de7f5e29"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb1bf0e04f33601f45c01516446d20b92f7195523f952b49e37e3b9df6f1d35c"
    sha256 cellar: :any,                 arm64_sequoia: "6333f736c870a3281ab985f60d7bc9ebf6794e03ad06cd0b25c036a9fadffe1e"
    sha256 cellar: :any,                 arm64_sonoma:  "96ade5ffd3bd722939e8e8ae5400bf37b076b81d6bfb555c711ad56df6c6c510"
    sha256 cellar: :any,                 sonoma:        "7abb7b04f9bcf03446bb731223e89cbd2b823275089948281d473959dbd70b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2baaec7a642c6c283025f3707d0691955b92a1636be59fb739748302ac9f5faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cb30f679858afb6133e09e3de793b2dded1e1e7b5dc5fd5796df2ad70d191b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

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
