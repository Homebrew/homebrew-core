class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.13.0/qxmpp-v1.13.0.tar.bz2"
  sha256 "c77709104cf669bafb59ad7d857c751afe9a055fc05b53e5f65e79e88bcd7b6c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fee7a1c8ec039173adaa064f1eb585fe3509e72f80f1de56bd04635a87ac8ec0"
    sha256 cellar: :any,                 arm64_sequoia: "f9f84ca714963164c58ccadbab079bc4417d16599230a1c470f15b1eeb4af674"
    sha256 cellar: :any,                 arm64_sonoma:  "a53a3da1d092100a0934884c9a36d25e2de6a3ce01297c9e6ec4d36577cc8135"
    sha256 cellar: :any,                 sonoma:        "ba391d9b6407b4605eb271600c02d6d38c4d531e00084c2098a2ecaff8e25a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12e0929a0cae1495797331526ab0d229dba802b0d8a32d7e53c20b2f96c790b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a6409b47e277a20222f54c666b93fb385155ca15530fd71830eb12baef0169"
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
