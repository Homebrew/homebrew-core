class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.1.0.tar.gz"
  sha256 "4d7da61c71ae816dbce724d4e717661e64dad300f2f079296ff65b88e8ca0676"

  bottle do
    cellar :any
    sha256 "5b846af291f3d9f68e84158edef9a60a49656f1f003814604ec4354bed59edd3" => :catalina
    sha256 "e3d88843eefafb7f80fc19ec1007008b3dde7aae2b828f703a733d2a24206fe2" => :mojave
    sha256 "7c0d7724342f11d53f8c14b3d561abbcd0ccee37e5f3ecb79f866725aea1690f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
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
