class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.9.3.tar.gz"
  sha256 "13f5162a1df720702c6ae15a476a4cb8ea3e57d861a992c4de9147909765e6de"
  revision 2

  bottle do
    cellar :any
    sha256 "fd7c98825fb816fe33a419fd35003ef012201209af0ed959646653ad0bd274a6" => :sierra
    sha256 "fd7c98825fb816fe33a419fd35003ef012201209af0ed959646653ad0bd274a6" => :el_capitan
    sha256 "16ed47b87aa37c5a758b37598236fbb2e3bd3562f30a8c6f38376454e23d53c2" => :yosemite
  end

  depends_on "qt"

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pro").write <<-EOS.undent
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

    (testpath/"test.cpp").write <<-EOS.undent
      #include <qxmpp/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert File.exist?("test"), "test output file does not exist!"
    system "./test"
  end
end
