class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.15.1/qxmpp-v1.15.1.tar.bz2"
  sha256 "3a492ed1a175f16101f6dae86074ec027b4bc068356a0cf881dd34a0b4130e61"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d6148bf2a7b06b7a383220e7441159828140ca7f9080f87a232b25a2b3e0564"
    sha256 cellar: :any,                 arm64_sequoia: "6f79da5128f78bcab6bfbf55236e0f53e50a6bad2de56b7fcd9f5a5c9e6c2a84"
    sha256 cellar: :any,                 arm64_sonoma:  "dc2dc9a32f2177e4962d2393e5f411634efd2b1630a02d07925943874991afe4"
    sha256 cellar: :any,                 sonoma:        "98996a0437486736cea5ec75aa93a4021dc4ebf117649c869554d5fbe0ff0850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbef993a997e0c6abb5d28d59323a73974d14fb275c54cb53c8bc009f6c64ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fe50d190bd252a30f6ab3ce737043ec4a609a76d934203aa8e376d38ce5e39d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "openssl@3"
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
