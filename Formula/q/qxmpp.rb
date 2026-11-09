class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.17.2/qxmpp-v1.17.2.tar.bz2"
  sha256 "810aefa4f6c5f64ab5f2e169d89d2a84b2c7c4cd52fe353b4afa366a23abe0bc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1eaa50568977f306197bf1d376baff881c74f8d6f1a6eb7caa1caf0f855da4e2"
    sha256 cellar: :any, arm64_tahoe:       "ed9afe14573f3f3104ce5ef43595175fa37028e746e141598cddf1f9dce3bd47"
    sha256 cellar: :any, arm64_sequoia:     "5373331d3539268cf328e16dc1faec4fcddc9c41221c735a4f91bc02347b9c63"
    sha256 cellar: :any, arm64_linux:       "d5ec7bcc010d075c32a8754b712b64e9b283967fae71e4e4f79176320be93770"
    sha256 cellar: :any, x86_64_linux:      "25720720b06e0644145edb892e61162288356a171bc470f02091d42e7450e639"
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
