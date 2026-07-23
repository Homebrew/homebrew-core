class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.16.3/qxmpp-v1.16.3.tar.bz2"
  sha256 "8a9833b8e991736584f46b2f70a7c0252366f69846a263fbc2db723628385cad"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "832deac9e6f650ebc0669e896b898244be3e24d09e40f58ea09de546a66c0c2c"
    sha256 cellar: :any, arm64_sequoia: "effe5b85403cfd24c7778ea64c96977bb24bdc153e5dd61140b4ca3ad521857f"
    sha256 cellar: :any, arm64_sonoma:  "b32fb781780170ba4f432405a6c65ccd01801468f2eb6aed83a95632b6bc6499"
    sha256 cellar: :any, sonoma:        "bf79c0f9f1d47a5efb13ccbf23c7543bc903b04c96179bc566a161be06c20a88"
    sha256 cellar: :any, arm64_linux:   "353f8ffa08bc4b1aaa1067a0b802c74c866274c8afbaadf96e604b679790d277"
    sha256 cellar: :any, x86_64_linux:  "982c446ead07867951052c839b093f81c679f042da3b50668323f7bae1d1b333"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
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

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
