class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.5.2.tar.gz"
  sha256 "cc26345428d816bb33e63f92290c52b9a417d9a836bf9fabf295e3477f71e66c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41ee2cc8d1ce336ab3ae51f6341b65615bf69fdff1fbc437079740180fb56388"
    sha256 cellar: :any,                 arm64_monterey: "7608654ff68ea5e85f247fe6b7a371da0253dabd4a5b52e77a5e39c349ac78cd"
    sha256 cellar: :any,                 arm64_big_sur:  "aa70f35f7bd948d48ad2f87979b59c09f0794ee980c3e5c712da9a8c84ddbf40"
    sha256 cellar: :any,                 ventura:        "a35b8b8aba3007ec5bef729f7acc3da1cd88aad702b61210b01fdb15ab43e1a1"
    sha256 cellar: :any,                 monterey:       "cabf6dfd56b1523f69d60cd6011408cde00a174558c94783649d05b2cf702ddd"
    sha256 cellar: :any,                 big_sur:        "26e7c8faf89cc2302f7b67fbc632c2e93111089fb072acfe2cd872ffbf80706d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02387de3793afccd0635bd8d77c19600a8d1ab8ce0e7d4cdaa6473f78e218917"
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
