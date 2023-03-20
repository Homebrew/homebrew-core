class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.5.3.tar.gz"
  sha256 "43ef503adcea8ef1a7eb0ce3af408eb693f66875550aaca9fd8309119e1afec8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99bb34cc1aeff8c463e0d7fdf2eeea628867fb6f54500fd822676729f5f11a31"
    sha256 cellar: :any,                 arm64_monterey: "b70a6d65d15f6266f48376629cbf1e26f74dd6f9debe97e8f951212508fdba69"
    sha256 cellar: :any,                 arm64_big_sur:  "65670571f1570a0d6b7d0ac73b3b7c3208affe0b12b35dd1789575c66fd7865a"
    sha256 cellar: :any,                 ventura:        "e606e07699925b882fe79636695ffd710e0569118c55debfa1315d6315a7c9f4"
    sha256 cellar: :any,                 monterey:       "dc4b2d884ae2e26f96084af18a02a7521a304aa9efb845a3772cebb4022cacc0"
    sha256 cellar: :any,                 big_sur:        "fcbdc25186717b0a181076a270f82d212914ba10e7e3398f87e480d2f96b8698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b2150808f860e55682f85f78ab876687a79a69a922d5dae06d353c20fc3f57"
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
      LIBS        += -lqxmpp
      QMAKE_RPATHDIR += #{lib}
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
