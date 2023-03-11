class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.5.3.tar.gz"
  sha256 "43ef503adcea8ef1a7eb0ce3af408eb693f66875550aaca9fd8309119e1afec8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5fb385b017377722f83eac85b8ed7b0e0d0f43385579b8094114cf54996151b7"
    sha256 cellar: :any,                 arm64_monterey: "5f353ce355b053c61216d26bdbc3e5f4d7c9bd39ac5b210db96f536d205f61fc"
    sha256 cellar: :any,                 arm64_big_sur:  "6dec127ef1d7bc9515126273ea265c903294a6bd3e798a38493f4cb3ffbb5871"
    sha256 cellar: :any,                 ventura:        "81bc5a12af5bf7eebd5eaa19a5d403ac44ba11e36d7ea1fb63b6d996866f72e8"
    sha256 cellar: :any,                 monterey:       "9a96061a0e5a481f89a77910ffb1e3266fcc6decb192db0418812c45769ad202"
    sha256 cellar: :any,                 big_sur:        "ed7474fc00f6cf9a5bf874e6c4801e130af71308a5319ab2e12c593e15a0e51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b352fb7533de5367c1b99f6191d7338f0e1759dd2335ef3dad755c1c8eac1c28"
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
