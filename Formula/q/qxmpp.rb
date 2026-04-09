class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.15.0/qxmpp-v1.15.0.tar.bz2"
  sha256 "61daa487682854374566c7997ad92fd429d2f09ccc673c8fe9cd0b1fbe134439"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "955738bb92acd15c6757c8af5dd31fe3b3b1ae0737228cfbb5963ce7efc862e8"
    sha256 cellar: :any,                 arm64_sequoia: "8984abf26c0b6637b924a7a59c37543d82b44edd9830a02f02a636275236beb8"
    sha256 cellar: :any,                 arm64_sonoma:  "a789da62c37229c74391293b6899cdd17f3368ee1aaf6dbf62578baf58f7871d"
    sha256 cellar: :any,                 sonoma:        "896fa52106d9cfa84957d20f686f67eea0281460a1a4fbdd3291825cd270abb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d93536bb57959d1ca606bf6c0c653b66483a2db36ff624b01af0185fdcf8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6797f9a88dfaed2c7c6964950ccd97f7cd6625d1ae2f90fe1eb40bcbfd20615"
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
