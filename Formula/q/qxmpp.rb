class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.17.0/qxmpp-v1.17.0.tar.bz2"
  sha256 "1c480d17489e0f83a976b670bb8a36b81e902152c9d5dcfe08b98e3d75f669e7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "094ee6d3d1a5618851256efe14a0a562a33a6fbd26527999f2202779095da085"
    sha256 cellar: :any, arm64_tahoe:       "98b97368021997b724a035e1d885ef2c0c9f68a416bbd2d884999a22bb0e91c7"
    sha256 cellar: :any, arm64_sequoia:     "b6508883459810aaa13fe43a9c05eed4d4a1076eb054a5cd365372890163158f"
    sha256 cellar: :any, arm64_linux:       "318136f1803adbb5edcd72330e8899d83540924c74c56fa5363ced198b47125b"
    sha256 cellar: :any, x86_64_linux:      "d0da451dbbb5676f140708acd832fef645fa754a46dba589890a5c0f38c5c9ed"
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
