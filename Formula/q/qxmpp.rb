class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "f307dde71dbaf9e17dc0472fafe68cabe2572b22ae759b6af24f8e1183b8db71"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "35ecf017c6e3831bfde3214cd3e3494640487ded3181aae0b976633fbd4b8357"
    sha256 cellar: :any,                 arm64_ventura:  "9552066925505dfbe08a5cf08047612e591b3df2e3ee5004f0bb582dd7d0e029"
    sha256 cellar: :any,                 arm64_monterey: "9154b994b01159d648d18cdfabc70f262905d6b34dbc8d65eaf5c2bdd86f6b13"
    sha256 cellar: :any,                 sonoma:         "f3a50a20f603418572d79ecb09ea82a3b0f7288358ef349fbca4a91c2ea8704f"
    sha256 cellar: :any,                 ventura:        "c2b5b8702dbd5705c238bd7ce83fb69515c81b265ea5298590ca5fa363125444"
    sha256 cellar: :any,                 monterey:       "a71c28054571afc618796c9b9b0193a9be622a94ea7dc8a1024ee6f58fac75a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29bd2b35ecf089919a9938af9fbeb2d582a364e3a53d14a3e21b60043be42fd1"
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

    (testpath/"test.cpp").write <<~EOS
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
