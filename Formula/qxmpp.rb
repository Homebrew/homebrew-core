class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.3.0.tar.gz"
  sha256 "3c83d7cb3e790afd62a5232956ca85378aa76b6e1d1875c921ead05b70bb0fa5"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "4c3019ce06ecc7202748b289ecbf1ac13f880f336de7d55f1e4ca717e6255d3e" => :catalina
    sha256 "7adb72c5f0920f8642cdbc768bee46e317594d261611c9ad91515c847afe9dee" => :mojave
    sha256 "3c656c837d070fb9cf7d6de56056636876440aa6d00bcae8f8dda8945f9581f2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build
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
