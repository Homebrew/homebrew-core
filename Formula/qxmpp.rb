class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.9.3.tar.gz"
  sha256 "13f5162a1df720702c6ae15a476a4cb8ea3e57d861a992c4de9147909765e6de"
  revision 1

  bottle do
    cellar :any
    sha256 "b91f3326670291f566231f7ea725759e1413324b2b3ea9998700c882dfeb4483" => :el_capitan
    sha256 "de52dfb3984ffad28bcc9f6dc79080e0f167132deaf159eec50b9fbe6328c575" => :yosemite
    sha256 "1ed8aeb55b725d9ea9f78be16a58d72ceb1b08c81c3ccc16f00634e552bc5514" => :mavericks
  end

  depends_on "qt5"

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

    system "#{Formula["qt5"].bin}/qmake", "test.pro"
    system "make"
    assert File.exist?("test"), "test output file does not exist!"
    system "./test"
  end
end
