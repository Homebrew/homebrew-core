class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "2691e2b28dfc45c4cda17ce04cf998b8c15f01bbf72f335e01b98a2f98063ef0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f144148c3442c45fa122bc8e3ce4f18cd382b35c54a212ff66ba8c3c157d94e2"
    sha256 cellar: :any,                 arm64_ventura:  "7ef3a34bf845fc392c87f856317f8dbc79367dd77e184ef8622142094ce6ce59"
    sha256 cellar: :any,                 arm64_monterey: "e1b320f14b18ed741a6d673104a79de69c88399e71f2d2e99a7bc22d545aae88"
    sha256 cellar: :any,                 sonoma:         "2fc5b1179f229e44ba5518837a5cd03d5afede07e7c08eb6661818dd818ff9b5"
    sha256 cellar: :any,                 ventura:        "829ba931758dd666880b64242999988eeb17ae3b4782e143bae3d9f79937a8fc"
    sha256 cellar: :any,                 monterey:       "9820b8a2430e4c1d29cf722e06b668e44b10786d4919b4900d95ed13270159af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8de810a3eab0af65a2787145e85a4178757b838052f0784e64b8de190a6db98"
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
