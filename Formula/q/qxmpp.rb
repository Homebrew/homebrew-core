class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "92f23238bc68d0f135a810454729c5da34312ebe2ae8f4bf9d303d2c3cde5e7d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2efc3ccfb7c3239a791d80f145771896cfc379f5f5f3c9837e49456bccc73a77"
    sha256 cellar: :any,                 arm64_ventura:  "60eeb17819f3b632b4764b71b3fe089ca2af262812e88449c63d407bc7e844c0"
    sha256 cellar: :any,                 arm64_monterey: "c1bb5b6c15ab30b79e484b3c7b5328457e64a1b8d4b060d8b928657efe2c0656"
    sha256 cellar: :any,                 sonoma:         "7f1c3dae3c450468c3c9606c6d72f6af44c4764f5288f8f0ce5dda50c77641ab"
    sha256 cellar: :any,                 ventura:        "8577d0aebbfeca487e3e94d8582ffe02ce4c2a686397ebe5299d5db3d71b7e98"
    sha256 cellar: :any,                 monterey:       "f0ae0ae3aff6f0748d6650e2a92cf914f538a6d30f7eeff6500b5b7bb55e321c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcc79f792a0b58c397a1a6a84a10477aa2a9129dd72cf8a09d56cf4935000e7"
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
