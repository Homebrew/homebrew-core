class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.4.0.tar.gz"
  sha256 "2148162138eaf4b431a6ee94104f87877b85a589da803dff9433c698b4cf4f19"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, big_sur:  "305342475120bce321cb8c08155abea73b9bea24bf13182a2c90f5d15b52f55d"
    sha256 cellar: :any, catalina: "3afe3b595811cbe3294fde018171c6af388f045ddc2a8c1dddda563d8713e5e0"
    sha256 cellar: :any, mojave:   "bab8c0aa083c76d3dd59674a1b001efe33624e5a37b03b02effbd098d9c24852"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
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
      LIBS        += -lqxmpp
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <qxmpp/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
