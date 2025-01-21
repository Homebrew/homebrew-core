class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "b6ddfe446ce5f628d3bc3a2a8d09ea86cdb9b7773435d112192e416f5a69981d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "5391364740c7d9cf8caeb61aad8036f2574caea70279d635c2c18c3ec1a52b11"
    sha256 cellar: :any,                 arm64_ventura: "13e937f25e987d999d22ae33e4b52aa4d12ab6d6d14e7ff9d4735fb7e25dd9e2"
    sha256 cellar: :any,                 sonoma:        "ca016236373415af1ac2f9cf6947bc1a504b7c448d1f085df01a08917a3c26f5"
    sha256 cellar: :any,                 ventura:       "205f6083faf8ba8c2979708b2470b249ac72c7bf1c1506a71bf53bfbd0e63197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689bb5ecf21ac76caa5ecba5f9652220daa0167536e7d6b2923f7a3fac8914fc"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

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
    (testpath/"test.pro").write <<~EOS
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
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
