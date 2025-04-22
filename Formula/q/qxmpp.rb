class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.10.3/qxmpp-v1.10.3.tar.bz2"
  sha256 "d36e6828dee496df14b7c2d3eac6c125c50645b869725b4535ecba443cafaa21"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "29058318e3f783571d8bda450b0dcc4c590839a28efff75c21f7ddc01f725c08"
    sha256 cellar: :any,                 arm64_ventura: "91a036eacde3da5f04e1d746a20ff7c5c4112f5550d38856c40454fc182f201d"
    sha256 cellar: :any,                 sonoma:        "aefe51ca697447f60bf7730ada2e915787b0c1428c3792de3ccd54ab78cd0be4"
    sha256 cellar: :any,                 ventura:       "d2506b6736edaffcdc2a0ed6208c0ccbeb317b5697e7fa79497c57227c5f94ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3277f6e73f001b58df75ae1129d7825299ec27beafe2d5e4a918e431e27a130b"
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
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
