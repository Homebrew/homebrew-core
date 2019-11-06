class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.1.0.tar.gz"
  sha256 "4d7da61c71ae816dbce724d4e717661e64dad300f2f079296ff65b88e8ca0676"

  bottle do
    cellar :any
    sha256 "269124872ad871b962223e342eb1170b0af84abf8e2e1dbc4cd5005cd51206fa" => :catalina
    sha256 "9c81c56a30502d584f18c3d6082ce5671845b69d7222678e3766696f69672062" => :mojave
    sha256 "3ac04dfac535d1fc68f7f536662bacf178fd8038dc11298df32ac68ee140eb46" => :high_sierra
    sha256 "6f78d2a082e84a482d64ce8cab4d811fa69f4e6fbf0bc2b5124c8751beb4c797" => :sierra
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
