class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.17.1/qxmpp-v1.17.1.tar.bz2"
  sha256 "13c0722ed2ad00d818467498539c3cbbf0c627d600cf8aafd0c3465f36cf9b08"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95b91ff22e70296b6143ac95860ad8d828f7b0573d602a3eb0d081b86a4dc9da"
    sha256 cellar: :any, arm64_tahoe:       "e92c76225a15034b4b22bc15b02ec50a529c9501e9c632f9ecf8a5e88107cdcb"
    sha256 cellar: :any, arm64_sequoia:     "14286cd80ae7e0161c76817e305a535847aee4584f5e3a485aa09bb54576978a"
    sha256 cellar: :any, arm64_linux:       "8b0949ec1c4cf330833d9771af6e4c885e334cfe505df642c775ee024e1e124d"
    sha256 cellar: :any, x86_64_linux:      "6d04ab1fea662d364c827cff19914ef5f21a0cabe4233132bd23a79fd5566f53"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
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

  deny_network_access!

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
