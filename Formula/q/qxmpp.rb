class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.5.5.tar.gz"
  sha256 "b25fba89432c4fd72489d1844f683bfbf4e5aa4cfcfda7a982d6019f8e4529f8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3162340ee6a93270da92fc42a26984d918f2413f93718d21ecc79eb2cdeb5289"
    sha256 cellar: :any,                 arm64_ventura:  "d099f396096a909f44fb368053dd8bea3caa4ee14dbfd67e466ef2f4fa532971"
    sha256 cellar: :any,                 arm64_monterey: "49e28d8d0daf588b67a846ae5f26338bfd3de47605058ea544b8fffbd7b07515"
    sha256 cellar: :any,                 arm64_big_sur:  "efd1db85c3eab76aeb8b4c3de5c220dc677d4481662b52b2663afdd0a9f8e30b"
    sha256 cellar: :any,                 sonoma:         "0cb3059df7b42c07eef38b32ebab3ed7c9f0348e8391293ae57e3e0fb36bbb82"
    sha256 cellar: :any,                 ventura:        "47b877829b1edf3aa0d2f7737b51beb216e8634212ef9cebf7301601354bb185"
    sha256 cellar: :any,                 monterey:       "ab94082c06216ca413b8f7ae6a9309947c8eb924f87032be24fd662ba0c2d0c1"
    sha256 cellar: :any,                 big_sur:        "435ebcc39eb2007d64392da737c15fc0fa065f68692afce5f9aa54c271ddae4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e2781798b80f1a83c0d82ef845fe1df06a0e5fa45716d8195a716d42036453"
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
