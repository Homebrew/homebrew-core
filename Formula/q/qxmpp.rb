class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.16.3/qxmpp-v1.16.3.tar.bz2"
  sha256 "8a9833b8e991736584f46b2f70a7c0252366f69846a263fbc2db723628385cad"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de355b907194c1a38ee2e87ac676f1b47d12d883b09f4f416fd155a48ee750d3"
    sha256 cellar: :any, arm64_tahoe:       "2bf56db80726cde0f650024143022d1056b478db8dddc2b1c142070272e5cc75"
    sha256 cellar: :any, arm64_sequoia:     "a8d4b84e843c0ba32b2e23b9c47abcb6e8f2548a6181cf77338a487b3a759262"
    sha256 cellar: :any, arm64_sonoma:      "dd6e6e560d2f48412bfc7e2f69b006f821a40d367d4c03deb3594f374c610a39"
    sha256 cellar: :any, arm64_linux:       "8e6debf0d0c5ed3bc3d990fa9c9d451c570ff70cbf7ace7ea692b6cae2e1f662"
    sha256 cellar: :any, x86_64_linux:      "05a6379521d5b41d48bf596a5067f691a5ca041a9284ea4b47af2402a78cd99c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++20 and GCC 13 crashes with ICE"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DOCUMENTATION=OFF", *std_cmake_args
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

    system formula_opt_bin("qtbase")/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
