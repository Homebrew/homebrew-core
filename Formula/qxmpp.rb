class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.5.4.tar.gz"
  sha256 "e437fdb91aa52c6fd8ca3f922354eb3221df98146ec99ee92e70e20a82c7ad2d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a101ff51563fbb5b6177278386d3d0f3afc18d3c7f9bb4965f2ceb0caa0d54b8"
    sha256 cellar: :any,                 arm64_monterey: "81ea3c3e9ceedf4c39dc173d3d2f3b741b6478bf8bf2c563faf9a3bb09eb3c62"
    sha256 cellar: :any,                 arm64_big_sur:  "61eb4c6bd42337e6a1283ef739c71de934657a237be7eee1515e39ca5072e3f3"
    sha256 cellar: :any,                 ventura:        "054fa6283164861d33af7bf18e0c23076cd1eb335bdf77c4b555f7bf3ecce169"
    sha256 cellar: :any,                 monterey:       "e33dba6faf74ee087978c6cc4832c428229adf22037789d5bc8f497cd3c2f097"
    sha256 cellar: :any,                 big_sur:        "c50266c0c19dfb104fd3522cb39bfeabb81e23a9ee2d681f17ec399ee151cc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65b6e8d9ee87f2dfc6a8f78ee623979b85aaff01c674cc8a7176be879f9b81b"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
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
