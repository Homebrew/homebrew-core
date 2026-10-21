class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.17.0/qxmpp-v1.17.0.tar.bz2"
  sha256 "1c480d17489e0f83a976b670bb8a36b81e902152c9d5dcfe08b98e3d75f669e7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7232bf82e274a902bf541718cb43d404545481299976b859c018548d15cba245"
    sha256 cellar: :any, arm64_tahoe:       "bfbda878563bdd741496f4972f13d5010f91c52eb4b446d7326f9429c2f72783"
    sha256 cellar: :any, arm64_sequoia:     "df0a21ebbb0b8ddf8a60fcec6b6384c7461a8de57d670b1d133d26cb04f897ca"
    sha256 cellar: :any, arm64_linux:       "54f13118756e3751341589ea5832700ccdbbccf5d776a79aa7ec475fd6fb524d"
    sha256 cellar: :any, x86_64_linux:      "be31a7531150b247043a85e450928d72de03544f6e77203570dead66e455bbce"
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
