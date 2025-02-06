class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "4403e43a0e8b6afa68f6e1e986e4ec19a08a6bf0db539ab7934a58afa1ddc532"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6b3c9dd9b4af0ecdd96a1528d3f2adde025d100d20071d99e7cc0665fdf9066e"
    sha256 cellar: :any,                 arm64_ventura: "e7f604cdb295218699911f6fed7a314b585729fc558ab0ee949b9411385ae226"
    sha256 cellar: :any,                 sonoma:        "dde69f86178c792344f834841ea9fc9adc677289d96b297b2684936f4375cf41"
    sha256 cellar: :any,                 ventura:       "8788539b96ad29ff2bf810dfa5de989547ca189fec89f1cb18b032fe60e4036b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a4aca609d1779b62673475e67e19105c5bab36a2360a38f13cea46a9555c43"
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
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
