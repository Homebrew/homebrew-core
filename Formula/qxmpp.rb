class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.9.3.tar.gz"
  sha256 "13f5162a1df720702c6ae15a476a4cb8ea3e57d861a992c4de9147909765e6de"
  revision 2

  bottle do
    cellar :any
    sha256 "0c733b26e6753a206dd7bc4340977c7392e0e86042aab643656b6a730b142a03" => :mojave
    sha256 "4a810995bced82af3afb6c9c56dd6d0ddaa8b89c191dc506433d31ffc7df2d19" => :high_sierra
    sha256 "2aae5596c491b1904299d29e8c309cf68debee312a1c613cc5b9dab3b8271777" => :sierra
    sha256 "f783c251ee39546cd4cbc893565f5174a4510d41ac4861932c53f02b3f621d96" => :el_capitan
    sha256 "6205c7bb9b62fbf5bcbce366e77c2a77992a3bcd88d5666e751a7dfee9202936" => :yosemite
  end

  depends_on "qt"

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lqxmpp
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <qxmpp/QXmppClient.h>
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
